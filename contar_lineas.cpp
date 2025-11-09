#include <iostream>
#include <fstream>
#include <string>
#include <windows.h>
#include <commdlg.h>

using namespace std;

string seleccionarArchivo() {
    OPENFILENAME ofn;       
    char szFile[MAX_PATH] = "";

    ZeroMemory(&ofn, sizeof(ofn));
    ofn.lStructSize = sizeof(ofn);
    ofn.hwndOwner = nullptr;
    ofn.lpstrFile = szFile;
    ofn.nMaxFile = sizeof(szFile);
    ofn.lpstrFilter = "Archivos de texto\0*.txt\0Todos los archivos\0*.*\0";
    ofn.nFilterIndex = 1;
    ofn.lpstrFileTitle = nullptr;
    ofn.nMaxFileTitle = 0;
    ofn.lpstrInitialDir = nullptr;
    ofn.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST;

    if (GetOpenFileName(&ofn)) {
        return string(ofn.lpstrFile);
    } else {
        return "";
    }
}

void contarLineas() {
    string rutaArchivo = seleccionarArchivo();

    if (rutaArchivo.empty()) {
        cout << "\nNo se seleccionó ningún archivo.\n" << endl;
        return;
    }

    ifstream archivo(rutaArchivo);
    if (!archivo.is_open()) {
        cerr << "\nError: no se pudo abrir el archivo.\n" << endl;
        return;
    }

    int contador = 0;
    string linea;
    while (getline(archivo, linea)) {
        contador++;
    }
    archivo.close();

    cout << "\nArchivo seleccionado: " << rutaArchivo << endl;
    cout << "Total de líneas: " << contador << "\n" << endl;
}

int main() {
    int opcion;

    do {
        cout << "==============================" << endl;
        cout << "   CONTADOR DE LINEAS v1.0" << endl;
        cout << "==============================" << endl;
        cout << "1) Seleccionar archivo y contar lineas" << endl;
        cout << "2) Salir" << endl;
        cout << "Elige una opcion: ";
        cin >> opcion;
        cin.ignore(); // limpiar el buffer

        switch (opcion) {
            case 1:
                contarLineas();
                system("pause");
                break;
            case 2:
                cout << "Saliendo del programa..." << endl;
                break;
            default:
                cout << "Opcion no valida.\n" << endl;
        }

        system("cls"); // limpia la consola (solo Windows)
    } while (opcion != 2);

    return 0;
}
