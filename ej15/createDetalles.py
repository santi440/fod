import os
import random
from datetime import datetime, timedelta

# Función para generar una fecha aleatoria en un rango específico
def random_date(start_date, end_date):
    delta = end_date - start_date
    random_days = random.randint(0, delta.days)
    return start_date + timedelta(days=random_days)

# Directorio donde se guardarán los archivos
path = os.path.dirname(os.path.realpath(__file__))
detalle_dir = os.path.join(path, "detalles")

# Crear el directorio si no existe
if not os.path.exists(detalle_dir):
    os.makedirs(detalle_dir)

# Definir el rango de fechas
start_date = datetime(2024, 1, 1)
end_date = datetime(2024, 12, 31)

# Generar 100 archivos de detalle
for i in range(1, 101):
    # Nombre del archivo
    filename = f"detalle{i}.txt"
    filepath = os.path.join(detalle_dir, filename)

    # Abrir el archivo para escribir
    with open(filepath, "w") as det:
        # Generar registros de ventas para el archivo
        registros = []
        for _ in range(random.randint(5, 20)):  # Número aleatorio de registros
            fecha = random_date(start_date, end_date)
            semanario = random.randint(1, 52)
            cantidad_vendida = random.randint(1, 100)
            registros.append((fecha, semanario, cantidad_vendida))

        # Ordenar los registros por fecha y código de semanario
        registros.sort(key=lambda x: (x[0], x[1]))

        # Escribir los registros en el archivo
        for registro in registros:
            det.write(f"{registro[0].strftime('%Y %m %d')} {registro[1]} {registro[2]}\n")

print("Archivos generados y ordenados correctamente.")
