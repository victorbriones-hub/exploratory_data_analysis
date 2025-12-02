

from lyft_connection import LyftConnection

import pandas as pd


class LyftGetData:

    def __init__(self):
        self.lyft_conn = LyftConnection()
        self.engine = self.lyft_conn.obtener_conexion_lyft()

    def obtener_datos_lyft(self, query):
        """
        Ejecuta una consulta SQL en la base de datos de Lyft y devuelve los resultados como un DataFrame de pandas.
        Args:
            query (str): Consulta SQL a ejecutar.
        Returns:
            pandas.DataFrame: Resultados de la consulta en un DataFrame.
        Raises:
            Exception: Si ocurre un error al ejecutar la consulta.
        Example:
            df = lyft_get_data.obtener_datos_lyft("SELECT * FROM rides LIMIT 10")
        """

        try:
            df = pd.read_sql_query(query, self.engine)
            return df
        except Exception as e:
            raise Exception(f"Error al ejecutar la consulta: {e}")
        


if __name__ == "__main__":
    # Solo se ejecuta si el archivo se corre directamente
    try:
        lyft_data = LyftGetData()
        consulta = "SELECT * FROM PaymentTypeDim LIMIT 10"  # Ejemplo de consulta
        df = lyft_data.obtener_datos_lyft(consulta)
        print(df)
        
    except Exception as e:
        print(f"❌ Error: {e}")