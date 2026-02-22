porcentaje_memoria=$(echo "scale=2;""100-$(cat /proc/meminfo | grep Mem | awk 'NR==3' | cut -d ":" -f 2 | cut -d " " -f 4)/$(cat /proc/meminfo | grep Mem | awk 'NR==1' | cut -d ":" -f 2 | cut -d " " -f 8)*100" | bc)
porcentaje_cpu=$(ps --no-headers -A -o %cpu | awk '{cpu = cpu + $1} END {printf "%3.0f", cpu}')
	
# KiB recibidos.
recibidos1=$(cat /proc/net/dev | grep wlp11s0)
recibidos2=${recibidos1:8}
recibidosi=$(echo "scale=10;""${recibidos2:0:-107}""/1024" | bc)

sleep 2

recibidos3=$(cat /proc/net/dev | grep wlp11s0)
recibidos4=${recibidos3:8}
recibidosf=$(echo "scale=10;""${recibidos4:0:-107}""/1024" | bc)

recibidos=$(echo "scale=3;""$recibidosf-$recibidosi" | bc)

# Kib transmitidos.
transmitidos1=$recibidos1
transmitidos2=${transmitidos1:68}
transmitidosi=$(echo "scale=10;""${transmitidos2:0:-48}""/1024" | bc)

transmitidos2=$recibidos3
transmitidos3=${transmitidos2:68}
transmitidosf=$(echo "scale=10;""${transmitidos3:0:-48}""/1024" | bc)

transmitidos=$(echo "scale=3;""$transmitidosf-$transmitidosi" | bc)

# Volumen.
volumen=$(pactl get-sink-volume @DEFAULT_SINK@ | grep "Volume" | cut -d "/" -f 2 | tr -d '[:space:]' | cut -d "%" -f 1)
icono=""

if [ $volumen -gt 50 ]; then
	icono=""
fi

# Vale «sí» si está mudo el altavoz y «no» si no lo está.
mudo=$(pactl get-sink-mute @DEFAULT_SINK@ | cut -d " " -f 2)

if [ "$mudo" = "sí" ]; then
	icono=""
fi

# Fecha
fecha=$(date "+%A %d de %B %H:%M")

# Separador
separador=" :: "

resultado=" $(echo $porcentaje_memoria | cut -d "." -f 1)%"$separador" $porcentaje_cpu%"$separador" $recibidos kiB/s  $transmitidos kiB/s"$separador"$volumen% $icono "$separador""$fecha""

xsetroot -name "$resultado"
#echo "$resultado"
sleep 2
