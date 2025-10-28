
from pathlib import Path

def create_project(nombre_proyecto):
    """
    Crea una estructura básica de proyecto con el nombre dado en una ruta específica.

    Args:
        nombre_proyecto (str): El nombre del proyecto a crear.
        ruta_destino (str | Path, optional): Ruta donde crear la carpeta del proyecto.
            Si es None, se usa el directorio actual.
    """
    ruta_destino = r"C:\Users\victor.briones\Documents\python_virtual_enviroments\exploratory_data_analysis\main\projects"
    
    ruta_destino = Path(ruta_destino) if ruta_destino else Path.cwd()
    proyecto_path = (ruta_destino / nombre_proyecto).resolve()
    proyecto_path.mkdir(parents=True, exist_ok=True)
    subdirectorios = ['data', 'notebooks', 'src', 'reports', 'docs', 'tests']

    print("Creando estructura de directorios... 🔄")

    for subdir in subdirectorios:
        (proyecto_path / subdir).mkdir(parents=True, exist_ok=True)
        print(f"✅ Creado directorio: {subdir}")

    print("\nCreando README.md... 🔄")

    readme_path = proyecto_path / 'README.md'
    readme_path.write_text(f"# {nombre_proyecto}\n\nDescripción del proyecto.\n", encoding='utf-8')
    print("✅ README.md creado")

    print(f"\n✨ Estructura de proyecto '{nombre_proyecto}' creada exitosamente ✨")


# Ejemplo de uso:
create_project("principales_indicadores_internos")