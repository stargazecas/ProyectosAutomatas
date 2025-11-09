import os
import tkinter as tk
from tkinter import filedialog, messagebox
#revisa si la extension del archivo es permitida
def contar_lineas(ruta_archivo, salida_texto):
    extensiones_validas = ['.txt', '.csv', '.log']
    _, extension = os.path.splitext(ruta_archivo)

    if extension.lower() not in extensiones_validas:
        salida_texto.insert(tk.END, f"Archivo no permitido: {ruta_archivo}\n")
        return
#si la extension del archivo es permitida entonces lee el archivo con readlines, que cada línea lo pone en una lista, y de aquí contamos cuantas líneas tiene el archivo.
# l.strip() quita los espacios en blanco de la linea
    try:
        with open(ruta_archivo, 'r', encoding='utf-8') as archivo:
            lineas = archivo.readlines()
            cantidad = len(lineas)
            vacias = sum(1 for l in lineas if not l.strip())
            con_texto = cantidad - vacias
#imprime el resultado
        salida_texto.insert(
            tk.END,
            f"{os.path.basename(ruta_archivo)} → {cantidad} líneas "
            f"({con_texto} con texto, {vacias} vacías)\n"
        )
    except UnicodeDecodeError:
        salida_texto.insert(tk.END, f"Error de codificación: {ruta_archivo}\n")
    except Exception as e:
        salida_texto.insert(tk.END, f"Error al leer {ruta_archivo}: {e}\n")

#abre el explorer de archivos, y predeterminadamente solo selecciona txt, csv y log, pero se puede seleccionar cualquier archivo.

def seleccionar_archivo(salida_texto):
    rutas = filedialog.askopenfilenames(
        title="Selecciona uno o más archivos",
        filetypes=[("Archivos de texto", "*.txt *.csv *.log"), ("Todos los archivos", "*.*")]
    )
    for ruta in rutas:
        contar_lineas(ruta, salida_texto)

#Gui, no importante
def main():
    root = tk.Tk()
    root.title("Contador de Líneas - Proyecto Lenguajes y Autómatas")
    root.geometry("600x400")
    root.resizable(False, False)

    # Botón para seleccionar archivo(s)
    boton = tk.Button(
        root,
        text="Seleccionar archivos",
        command=lambda: seleccionar_archivo(salida_texto),
        font=("Segoe UI", 11),
        width=25,
        bg="#4CAF50",
        fg="white"
    )
    boton.pack(pady=15)

    # Cuadro de salida
    salida_texto = tk.Text(root, wrap=tk.WORD, height=15, width=70, font=("Consolas", 10))
    salida_texto.pack(padx=10, pady=10)
    salida_texto.insert(tk.END, "Selecciona un archivo para contar sus líneas...\n")

    # Botón de salida
    boton_salir = tk.Button(root, text="Salir", command=root.destroy, bg="#E53935", fg="white", width=10)
    boton_salir.pack(pady=5)

    root.mainloop()

if __name__ == "__main__":
    main()
