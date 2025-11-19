

class lyft_database:

    credentials_path = '../configurations/lyft_conection.json'

    def __init__(self, credentials_path=None):
        if credentials_path is not None:
            self.credentials_path = credentials_path
        else:
            self.credentials_path = self.credentials_path

    def obtener_conexion_lyft(self):
        from sqlalchemy import create_engine
        import json

        with open(self.credentials_path, 'r') as file:
            lyft_credentials = json.load(file)

            
        """ 
         {
    "SERVER": "datamart.mex.lyftbikes.com",
    "DATABASE": "mex_datawarehouse_bss4",
    "USERNAME": "dm_mex_ge",
    "PASSWORD": "m+y#J9JI9F+^4qjSJLu^R"
}
          
         """
        server = lyft_credentials['SERVER']
        base_datos = lyft_credentials['DATABASE']
        username = lyft_credentials['USERNAME']
        contrasena = lyft_credentials['PASSWORD']

        conexion_string = f"mysql+pymysql://{username}:{contrasena}@{server}/{base_datos}"
        
        engine = create_engine(conexion_string)

        return print("Conexión exitosa con Lyft: ", engine)
    
    def obtner_datos_lyft(self, consulta_sql):
        import pandas as pd

        engine = self.obtener_conexion_lyft()
        df = pd.read_sql(consulta_sql, engine)

        return df
    
    def cerrar_conexion_lyft(self, engine):
        engine.dispose()


lyft_db = lyft_database()

# Ejemplo de uso:
print(lyft_db.obtener_conexion_lyft())

consulta = """
    SELECT 
        id,
        localizedValue0
    FROM PaymentTypeDim
"""

df_lyft = lyft_db.obtner_datos_lyft(consulta)
print(df_lyft)

