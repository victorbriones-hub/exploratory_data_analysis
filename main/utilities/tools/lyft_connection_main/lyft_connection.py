

from sqlalchemy import create_engine
import json

class LyftConnection:

    def __init__(self, credentials_path = '../../configurations/lyft_conection.json'):
        
        self.credentials_path = credentials_path
        self.engine = None
        self.cargar_credenciales()

    def validar_archivo_json(self):
        """
        Lee y valida el archivo JSON de credenciales ubicado en la ruta definida por `self.credentials_path`.
        La función intenta abrir el archivo y cargar su contenido como un diccionario. En caso de que el archivo no exista
        o su contenido no sea un JSON válido, se lanzan excepciones específicas.
        Returns:
            dict: Diccionario con las credenciales de Lyft cargadas desde el archivo JSON.
        Raises:
            FileNotFoundError: Si el archivo de credenciales no se encuentra en la ruta especificada.
            ValueError: Si el archivo existe pero su contenido no es un JSON válido.
        Example:
            credenciales = self.validar_archivo_json()
            token = credenciales.get("access_token")
        """
        try:
            with open(self.credentials_path, 'r') as file:
                lyft_credentials = json.load(file)
            return lyft_credentials
        except FileNotFoundError:
            raise FileNotFoundError(f"No se encontró el archivo de credenciales en la ruta: {self.credentials_path}")
        except json.JSONDecodeError:
            raise ValueError("El archivo de credenciales no es un JSON válido")
        
    def cargar_credenciales(self):
        lyft_credentials = self.validar_archivo_json()
        required_keys = ['SERVER', 'DATABASE', 'USERNAME', 'PASSWORD']
        for key in required_keys:
            if key not in lyft_credentials:
                raise KeyError(f"La clave '{key}' falta en el archivo de credenciales")
        return True

    def obtener_conexion_lyft(self):
        """
        Establece y devuelve una conexión (Engine de SQLAlchemy) a la base de datos de Lyft.
        Flujo:
        1. Obtiene y valida las credenciales desde un archivo JSON mediante self.validar_archivo_json().
        2. Carga credenciales adicionales en el contexto del objeto con self.cargar_credenciales().
        3. Construye el string de conexión con el driver pymysql y crea el Engine de SQLAlchemy.
        Returns:
            sqlalchemy.engine.Engine: Instancia de Engine conectada a la base de datos especificada.
        Side Effects:
            Imprime mensajes de confirmación en consola.
        Raises:
            FileNotFoundError: Si el archivo de credenciales no existe.
            json.JSONDecodeError: Si el contenido del archivo JSON es inválido.
            KeyError: Si falta alguna clave esperada (SERVER, DATABASE, USERNAME, PASSWORD).
            ImportError: Si no está instalado el paquete requerido (pymysql o SQLAlchemy).
            sqlalchemy.exc.SQLAlchemyError: Si ocurre un error al crear la conexión.
        Notas:
            - Asegúrate de que el archivo de credenciales tenga las claves: SERVER, DATABASE, USERNAME, PASSWORD.
            - Evita imprimir credenciales en logs. Los prints actuales son informativos pero pueden ajustarse para producción.
            - Requiere: SQLAlchemy y pymysql instalados.
        """

        lyft_credentials = self.validar_archivo_json()
        self.cargar_credenciales()

        server = lyft_credentials['SERVER']
        base_datos = lyft_credentials['DATABASE']
        username = lyft_credentials['USERNAME']
        contrasena = lyft_credentials['PASSWORD']

        conexion_string = f"mysql+pymysql://{username}:{contrasena}@{server}/{base_datos}"

        engine = create_engine(conexion_string)

        return engine
    

if __name__ == "__main__":
    # Solo se ejecuta si el archivo se corre directamente
    try:
        lyft_conn = LyftConnection()
        engine = lyft_conn.obtener_conexion_lyft()
        print("✅ Conexión a la base de datos de Lyft establecida correctamente.")
        
    except Exception as e:
        print(f"❌ Error: {e}")
