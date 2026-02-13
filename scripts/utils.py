import json
from typing import Dict, Any
import sqlite3, time
import pandas as pd
import unicodedata
import re


####################
# Utility functions

def clean_data(df:pd.DataFrame) -> pd.DataFrame:
    # Trim les douuble quotes en début et fin de colonnes
    df.columns = df.columns.str.strip('"')

    # Réhydrater les dates au format datetime
    for col in get_date_columns(df):
        df[col] = pd.to_datetime(df[col], 
            infer_datetime_format=True,  # Plus rapide que le parsing standard
            errors='coerce')             # En cas d'erreur de parsing, remplace par NaT (Not a Time) au lieu de lever une exception
    
    return df


def get_date_columns(df, keywords=['date', 'timestamp']):
    """Detecte les colonnes de type date en se basant sur des mots-clés dans le name de la colonne."""
    return [col for col in df.columns 
            if any(keyword in col.lower() for keyword in keywords)]


def norm(name: str) -> str:
    # Gestion du cas où la valeur est manquante
    if pd.isna(name):
        return None

    # Trim + minuscules
    name = name.strip().lower()

    # Suppression des accents

    # Décompose chaque caractère Unicode présent dans la chaîne name selon le formulaire de normalisation
    # NFKD (Normalization Form Compatibility Decomposition).
    name = unicodedata.normalize("NFKD", name)

    # Supprime les caractères d'accent (marques de combinaison) obtenus après la normalisation NFKD,
    # afin de ne garder que les lettres de base, les chiffres, les espaces, etc.
    name = "".join(ch for ch in name if not unicodedata.combining(ch))

    # Collapsing des espaces multiples
    name = re.sub(r"\s+", " ", name)

    return name



def get_perf_stats(sql: str) -> str:
    """Exécute la requête SQL, mesure le temps et renvoie le résultat."""
    start = time.perf_counter()

    # 👉  Connexion et curseur créés ici, donc même thread
    with sqlite3.connect('./olist.db', check_same_thread=False) as con:
        con.row_factory = sqlite3.Row      # (optionnel) pour accéder aux colonnes par nom
        cur = con.cursor()
        cur.execute(sql)
        rows = cur.fetchall()           # force le fetch complet

    elapsed = time.perf_counter() - start
    return rows[:20], len(rows), elapsed



#################
# Utility class

class QueryBenchmark:

    def __init__(self):
        base_path = Path(__file__).parent
        json_path = base_path / "stat_dict.json"
        with open(json_path, 'r') as p:
            self.data = json.load(p)

    def _validate_path(self, category: str, query: str, version: str):
        if category not in self.data:
            raise ValueError(f"Unknown category: {category}")

        if query not in self.data[category]:
            raise ValueError(f"Unknown query: {query}")

        if version not in ["raw", "optimized"]:
            raise ValueError("Version must be 'raw' or 'optimized'")

    def set_stats(self, category: str, query: str, version: str,
                    rows: int, time: float) -> None:
        """
        Set stats for a given query.
        """
        self._validate_path(category, query, version)

        self.data[category][query][version] = {
            "rows": rows,
            "time": time
        }

    def get_stats(self, category: str, query: str, version: str) -> Dict[str, Any]:
        """
        Get stats for a given query.
        """
        self._validate_path(category, query, version)
        return self.data[category][query][version]

    def compare(self, category: str, query: str) -> Dict[str, Any]:
        """
        Compare raw vs optimized for a given query.
        Returns difference and percentage improvement.
        """
        if category not in self.data:
            raise ValueError(f"Unknown category: {category}")

        if query not in self.data[category]:
            raise ValueError(f"Unknown query: {query}")

        raw = self.data[category][query].get("raw", {})
        optimized = self.data[category][query].get("optimized", {})

        raw_rows = raw.get("rows", 0)
        raw_time = raw.get("time", 0)

        opt_rows = optimized.get("rows", 0)
        opt_time = optimized.get("time", 0)

        return {
            "rows_difference": raw_rows - opt_rows,
            "time_difference": raw_time - opt_time,
            "rows_improvement_percent": (
                ((raw_rows - opt_rows) / raw_rows * 100)
                if raw_rows > 0 else 0
            ),
            "time_improvement_percent": (
                ((raw_time - opt_time) / raw_time * 100)
                if raw_time > 0 else 0
            )
        }

    def to_dict(self) -> Dict[str, Any]:
        return self.data
