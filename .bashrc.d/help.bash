assistance_body="";

function Assistance(){
    echo "Utilidades incluidas:";
    echo -e $assistance_body;
};


function registerAssistance(){
    body="${c_white}$1:${c_null} $2\n";
    assistance_body+=$body;
}

function registerAssistanceSection(){
    title=`echo "$1" | tr '[:lower:]' '[:upper:]'`
    body="${c_light_cyan}$title:${c_null}\n";
    assistance_body+=$body;
}