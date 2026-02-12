import sqlite3, time
import pandas as pd
import unicodedata
import re


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



def benchmark_query(sql: str) -> str:
    """Exécute la requête SQL, mesure le temps et renvoie le résultat."""
    start = time.perf_counter()

    # 👉  Connexion et curseur créés ici, donc même thread
    with sqlite3.connect('./olist.db', check_same_thread=False) as con:
        con.row_factory = sqlite3.Row      # (optionnel) pour accéder aux colonnes par nom
        cur = con.cursor()
        cur.execute(sql)
        rows = cur.fetchall()           # force le fetch complet

    elapsed = time.perf_counter() - start
    return rows[:20], f"Fetched {len(rows)} rows in {elapsed:.3f}s"