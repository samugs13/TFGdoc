# Script original de Carlos Molina (https://github.com/cmolinaord).
# Este script ha sido modificado por mí para mi uso personal.

let N=0
let n=0

echo "Figuras no usadas:"
for fig in $(ls -R --color=always imgs); do
    let N=N+1
    grep $fig tex/*.tex &> /dev/null
    if [[ $? == 1 ]]; then
        let n=n+1
        echo "   $fig";
    fi;
done

echo " "
echo $n figuras no usadas de $N
