
# DOKERIZANDO PROGRAMAS UTILES DE TERMINAL
##      (youtube-dl, pdftk, ffmpeg, convert)

Con el tiempo de uso de linux, se va cogiendo cariño al terminal, y he ido recopilando algunos programas que resulta muy utiles en determinadas ocasiones.

Al cambiar de ordenardor me he dado cuenta que hay que volver a instalar todo, y sobre todo programas que no se usan mucho, pero que son necesarios en determinadas ocasiones, buscar una manera de tenerlos pero no tener que volver a instalarlos.

Por ello una solución ideal es **Docker** tener un contenedor con todos estos programas, con la ventaja de tenemos disponibles en cualquier momento para usuarlos en cualquier equipo, no ocupan espacio de disco, no generan dependencias, ...

# INSTRUCCIONES

Y ya podemos correr y usar el contenedor

    docker run --rm --user $UID:UID -v $PWD:/downloads manologcode/terminal_util [pdftk] [youtube-dl] [ffmpeg] [convert]

ejemplo (crear una git amimada)

    docker run --rm -v $PWD:/downloads manologcode/terminal_util convert -layers OptimizePlus -delay 200 -size 260x360 -quality 99 *.png -loop 0 ps1.gif


Para su uso más comodo podemos cargar los comandos en el la sesion actual de shell con el comando

    source sourceUtil

con el uso de este comando conseguimos cargar los programas como si los tubiesemos instalados en nuestro ordenador durante la sesion del terminal. Tambien esta la posiblidas de generar alias si hacemos uso mas habitual de esto programas.

se copia el archivo sourceUtil en el home del usuario y se puede invocar al programa desde cualquier sitio con:

    source ~/sourceUtil


# UTILIDADES

Algunas combinaciones mas habituales de uso de estos programas

# youtube'dl

Es una aplicación que nos permite descargar video de youtube

    youtube-dl http://youtube.com/el-video-que-sea

Leer de Archivo -t para añadir el titulo y -f18 en alta calida,mp4

    youtube-dl -t -f18 -a video.txt

Lista de distrubucion

    youtube-dl -t -f18 https://www.youtube.com/playlist?list=PL53398BADD9369A3F

Descargar y convertir a MP3

    youtube-dl -x --audio-format mp3 http://youtube.com/el-video-que-sea

# IMAGENES

## Crear una git animada a partir de varias imagenes

    convert -layers OptimizePlus -delay 200 -size 260x360 -quality 99 *.png -loop 0 ps1.gif

## Convertir imagenes a blanco y negro

    convert -colorspace gray origen.jpg destino.jpg;

Conversión masiva

    for i in *.jpg;do convert -colorspace gray "$i" ${i%.jpg}bn.jpg; done

## Unir varias imagenes en un pdf tamaño A4

    convert -page A4 -compress jpeg *.jpg libro.pdf    

## redimensiona imagenes

    convert -resize 400×300 file.jpg file2.jpg

todas las de la carpeta

for i in *.jpg;do convert -resize 30 "$i" ${i%.jpg}_n.jpg; done

# PDFs

## Desproteger documento PDF

    qpdf --decrypt nombre_pdf_protegido.pdf nombre_pdf_desprotegido.pdf

## Combinar todos los documentos pdf en uno

    pdftk *.pdf output libro.pdf

## Dividir PDF en hojas

    pdftk archivo_grande.pdf burst

## Rotar todas la paginas del documento

    pdftk libro.pdf cat 1-endE output rotado.pdf

## Convertir un pdf a imagenes

    convert foo.pdf foo.png    

## Reducir tamaño de documentos PDF

Para realizar la conversión-optimización

    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=optimizado.pdf original.pdf

    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=memoria2014.pdf rotado.pdf

Pero y si ¿aún sigue siendo muy grande? tenemos otro comando que aún lo reduce más:

    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=optimizado.pdf original.pdf

Otro metodo

    gs -dSAFER -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -sOutputFile="memoria2014a.pdf" "memoria2014.pdf"

todo los pdfs de la carpeta

    for i in *.pdf; do gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=a/"$i" "$i"; done   

### Numera PDF

crear un archivo con la numeros.pdf

    pdftk numeros.pdf multibackground Catalogo2018.pdf output resultado.pdf

## CONVERTIR PDF DE RGB A CMYK

    gs -dSAFER -dBATCH -dNOPAUSE -dNOCACHE -sDEVICE=pdfwrite -sColorConversionStrategy=CMYK -dProcessColorModel=/DeviceCMYK -sOutputFile=document_cmyk.pdf documentoRGB.pdf

# VIDEO

## From DV To AVI  sin comprimir

    ffmpeg -i input.dv -vcodec copy -vtag dvsd -acodec pcm_s16le -f avi -aspect 4:3 -y output.avi

## From DV To MKV comprimido

    ffmpeg -i archivo.dv -c:v libx264 -preset slow -crf 22 -c:a copy archivo.mkv

Converion masiva

    for i in *.dv; do ffmpeg -i "$i"  -c:v libx264 -preset slow -crf 22 -c:a copy "$i".mkv; done
    
## From FLV to mp4

    ffmpeg -i input.flv -c:v libx264 -crf 19 -strict experimental filename.mp4
    Converion masiva
    for i in *.flv; do ffmpeg -i "$i"  -c:v libx264 -crf 19 -strict experimental "$i".mp4; done

## From VOB to MP4

unir archivos vob  cat *.VOB > movie.vob

    ffmpeg -y -i movie.vob -f mp4 -r 29.97 -vcodec libx264 -preset slow -b:v 3800k -flags +loop -cmp chroma -b:v 4000k -maxrate 4300k -bufsize 4M -bt 256k -refs 1 -bf 3 -coder 1 -me_method umh -me_range 16 -subq 7 -partitions +parti4x4+parti8x8+partp8x8+partb8x8 -g 250 -keyint_min 25 -level 30 -qmin 10 -qmax 51 -qcomp 0.6 -trellis 2 -sc_threshold 40 -i_qfactor 0.71 -c:a aac -b:a 125k -ar 48000 -ac 2 outfile.mp4

## Convertir de mp4 a mp3

    ffmpeg -i filename.mp4 filename.mp3
    con opciones
    ffmpeg -i filename.mp4 -b: un filename.mp3 -vn 192K

Masiva

    for i in *.mp4;do ffmpeg -i $i -q:a 1 -vn ${i%.mp4}.mp3; done

## Convertir de Mp4 a webm

    ffmpeg -i sourcevideo.mp4 -vcodec libvpx -acodec libvorbis -aq 5 -ac 2 -qmax 25 -b 614400 -s 1280×720 Outputvideo.webm

## Reducir Videos para usarlos de background

WebM:

    ffmpeg -i original.mp4 -c:v libvpx -preset slow -s 1024x576 -qmin 0 -qmax 50 -an -b:v 400K -pass 1 homepage.webm

MP4

    ffmpeg -i original.mp4 -c:v libx264 -preset slow -s 1024x576 -an -b:v 370K homepage.mp4

# sonido

## aumentar el volument de archivo

    ffmpeg -i <archivo-de-entrada> -filter:a "volume=1.5" <archivo-de-salida>

todas las de la carpeta

    for i in *.mp3;do ffmpeg -i "$i" -filter:a "volume=2" ${i%.mp3}_n.mp3; done
