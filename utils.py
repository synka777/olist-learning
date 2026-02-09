import pandas as pd


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
    """Detecte les colonnes de type date en se basant sur des mots-clés dans le nom de la colonne."""
    return [col for col in df.columns 
            if any(keyword in col.lower() for keyword in keywords)]