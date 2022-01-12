# Créditos: Carlos Molina (https://github.com/cmolinaord)

OUTPUT_DIR = pdf
SRC_DIR = tex
TEX = latexmk -cd- -pdf -outdir=$(OUTPUT_DIR) --shell-escape # -cd- es para que no cambie al directorio de origen cuando se haga la compilación 

all:
	echo "make tfg:                          Compile the TFG from latex to pdf into pdf/ dir"
	echo "make prev:                     	 Show the TFG pdf result"
	echo "make clean:                        Remove the auxiliary files and logs in the output dir"
	echo "count_words:                       Count number of words in the whole document"
	echo "debug_warnings:                    Review '%WARNINGS' messages during the text put by the writer"
	echo "debug_figures:                     Show all the figures calls or references"
	echo "debug_figures_unused:              Show all the images in the repo that are not actually used in the document"
	echo "debug_label_chapters:              Show all the chapters that do not have a \label"
	echo "list_bibliography_used:            List the actual bibliography referenced within the document"

tfg: $(OUTPUT_DIR)/tfg.pdf

        $(OUTPUT_DIR)/tfg.pdf: $(SRC_DIR)/tfg.tex
	mkdir -p $(OUTPUT_DIR)
	$(TEX) $(SRC_DIR)/tfg.tex

prev: tfg
	$(TEX) $(SRC_DIR)/tfg.tex -pvc

clean:
	rm $(OUTPUT_DIR)/*{aux,log,toc,out,fls,fdb_latexmk}

count_words:
	pdftotext "$(OUTPUT_DIR)/tfg.pdf" - |grep -v "^[0-9]" | wc -w 

debug_label_chapters:
	echo "Mostrando capitulos que no tienen ningun /label"
	grep -n -E '(\\chapter|\\(sub)*section)' $(SRC_DIR)/*.tex | grep -v -E '\\label' | sed 's/:/:\t/g'

debug_figures:
	echo "Mostrando todas las llamadas a etiquetas o referencias a figuras"
	grep -n "fig:" $(SRC_DIR)/*.tex

debug_figures_unused:
	./scripts/search_unused.sh 

debug_warnings:
	echo "Mostrando lineas con WARNINGS:"
	grep -n -A1 "^%WARNING" $(SRC_DIR)/*.tex | grep -v "WARNING" | sed 's/-%/: /'
	echo " "

list_bibliography_used:
	grep -n "\cite" tex/*.tex
