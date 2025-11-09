begin

#no supe como poner un selector de archivos normal, tonces con powershell chingue su madre; si está viendo esto entonces no eres casta entonces botate a la verga-
def seleccionar_archivo
  script = <<~POWERSHELL
    Add-Type -AssemblyName System.Windows.Forms
    $f = New-Object System.Windows.Forms.OpenFileDialog
    $f.Title = 'Selecciona el archivo fuente a analizar'
    $f.Filter = 'Todos los archivos (*.*)|*.*'
    if ($f.ShowDialog() -eq 'OK') { Write-Output $f.FileName }
  POWERSHELL

  ruta = `powershell -Command "#{script}"`
  ruta.strip
end

#tokens que vimos en clase
TOKENS = {
  'PALABRAS_RESERVADAS' => {
    'if' => -1, 'then' => -2, 'else' => -3,
    'for' => -4, 'while' => -5, 'read' => -6, 'readln' => -7
  },
  'OPERADORES_ARITMETICOS' => {
    '+' => -51, '-' => -52, '*' => -53, '/' => -54
  },
  'OPERADORES_RELACIONALES' => {
    '>' => -61, '<' => -62, '>=' => -63, '<=' => -64, '=' => -65
  },
  'OPERADORES_LOGICOS' => {
    'and' => -81, 'or' => -82, 'not' => -83
  },
  'SIMBOLOS' => {
    '(' => -71, ')' => -72, '[' => -73, ']' => -74, '{' => -75, '}' => -76
  },
  'CONSTANTES' => {
    'ENTERA' => -41, 'REAL' => -42, 'STRING' => -43
  },
  'IDENTIFICADORES' => {
    'GENERICA' => -21, 'ENTERO' => -22, 'REAL' => -23,
    'STRING' => -24, 'RUTINA' => -25
  }
}

#Selección del archivo
archivo = seleccionar_archivo
if archivo.empty?
  puts "No se seleccionó ningún archivo."
  exit
end

codigo = File.read(archivo).split("\n")

#analisis lexico
tabla = []
codigo.each_with_index do |linea, num_linea|
  # Eliminar comentarios tipo # o // (dios mio que sufrimiento de cosa me voy a suicidar)
  linea = linea.gsub(/#.*$/, '').gsub(/\/\/.*$/, '')

  # guardar/no líneas vacías después de quitar los comentarios
  next if linea.strip.empty?

  # Extraer lexemas válidos
  lexemas = linea.scan(/[A-Za-z_]\w*|\d+|>=|<=|==|[+\-*\/=<>\[\]\(\)\{\}]|\/\*[\s\S]*?\*\//)
  lexemas.each_with_index do |lexema, _|
    token = nil
    posicion = -1

    case
    when TOKENS['PALABRAS_RESERVADAS'].key?(lexema)
      token = TOKENS['PALABRAS_RESERVADAS'][lexema]
    when TOKENS['OPERADORES_ARITMETICOS'].key?(lexema)
      token = TOKENS['OPERADORES_ARITMETICOS'][lexema]
    when TOKENS['OPERADORES_RELACIONALES'].key?(lexema)
      token = TOKENS['OPERADORES_RELACIONALES'][lexema]
    when TOKENS['OPERADORES_LOGICOS'].key?(lexema)
      token = TOKENS['OPERADORES_LOGICOS'][lexema]
    when TOKENS['SIMBOLOS'].key?(lexema)
      token = TOKENS['SIMBOLOS'][lexema]
    when lexema.match?(/^\d+$/)
      token = TOKENS['CONSTANTES']['ENTERA']
    when lexema.match?(/^[A-Za-z_]\w*$/)
      token = TOKENS['IDENTIFICADORES']['GENERICA']
      posicion = -2
    else
      token = 0
    end

    tabla << [lexema, token, posicion, num_linea + 1]
  end
end

#resultado, 
puts "\n=== TABLA DE TOKENS ==="
puts "Cadena\tToken\tPosición\tLínea"
puts "-" * 40
tabla.each { |c, t, p, l| puts "#{c.ljust(8)}\t#{t}\t#{p}\t\t#{l}" }

File.open("tabla_tokens.txt", "w") do |f|
  f.puts "Cadena\tToken\tPosición\tLínea"
  tabla.each { |c, t, p, l| f.puts "#{c}\t#{t}\t#{p}\t#{l}" }
end

puts "\nTabla guardada en 'tabla_tokens.txt'"

rescue => e
  puts "Error al leer el archivo: #{e.message}"
end

