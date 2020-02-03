# Usage: ncat -lC <port_number> -c 'sh tpg300sim.sh'
# or
# Usage: nc -lC -p <port_number> --sh-exec 'tpg300sim.sh'

ETX=$'\x03'
ENQ=$'\x05'
ACK=$'\x06'
NAK=$'\x15'

sim_state="tpg300sim_state"

puc="0"
units="1"
baud="1"
version="-- VERSION"
# No boards at all
tid="NO P,NO P,NO P"
# Interface board
tid="NO P,NO P,IF300"
# Cold cathode meas boards and interface board
tid="PE300,PE300,IF300"
sav="0"
pressure="0,1.0E-11"
mode="3,3,3,3"
filter="1,1,1,1"
func_stat="0,0,0,0,0,0"
func_param="1.0E-10,1.0E-1,0"
func_params[0]="1.0E-10,1.0E-1,0"
func_params[1]="1.0E-10,1.0E-1,1"
func_params[2]="1.0E-10,1.0E-1,0"
func_params[3]="1.0E-10,1.0E-1,3"
func_params[4]="1.0E-10,1.0E-1,0"
err="0000"
state="$err"


function cmd_handle {

    if [[ $1 =~ $ETX ]]; then
        echo "=====" 1>&2
        echo "RESET" 1>&2
        echo "=====" 1>&2
        return
    fi

    if [[ $1 =~ $ENQ ]]; then
        echo $state
        echo "reply   $state" 1>&2
        return
    fi

    cmd=$(tr -dc '[[:print:]]' <<< "$1");

    if [[ ! -e $sim_state ]]; then
        touch $sim_state
    fi

    if [[ "$cmd" =~ ^OFF$ ]]; then
        echo $cmd > $sim_state
        echo -e "\nsimulator $cmd\n" 1>&2
        return
    elif [[ "$cmd" =~ ^ON$ ]]; then
        echo $cmd > $sim_state
        echo -e "\nsimulator $cmd\n" 1>&2
        return
    fi


    if [[ "$(cat $sim_state)" =~ ^OFF$ ]]; then
        return
    fi


    if [[ "$cmd" =~ ^ERR$ ]]; then
        state=$err

    elif [[ "$cmd" =~ ^SP[1234AB]$ ]]; then
        relay=${cmd:2}
        if [[ "$relay" != "A" && "$relay" != "B" ]]; then
            state=${func_params[$relay]}
        else
            state=$func_param
        fi

    elif [[ "$cmd" =~ ^SP[1234AB],*,*,[0-9] ]]; then
        func_param=${cmd#SP?,}
        state=$func_param

    elif [[ "$cmd" =~ ^SPS$ ]]; then
        state=$func_stat

    elif [[ "$cmd" =~ ^FIL$ ]]; then
        state=$filter

    elif [[ "$cmd" =~ ^FIL,[1-3],[1-3],[1-3],[1-3]$ ]]; then
        filter=${cmd#FIL,}
        state=$filter

    elif [[ "$cmd" =~ ^SEN$ ]]; then
        state=$mode

    elif [[ "$cmd" =~ ^SEN,[0-3],[0-3],[0-3],[0-3]$ ]]; then
        mode=${cmd#SEN,}
        state=$mode

    elif [[ "$cmd" =~ ^P[AB][12]$ ]]; then
        pressure=0,$((RANDOM%9 + 1)).$((RANDOM%10))E-$((RANDOM%5 + 10))
        state=$pressure

    elif [[ "$cmd" =~ ^TID$ ]]; then
        state=$tid

    elif [[ "$cmd" =~ ^PNR$ ]]; then
        state=$version

    elif [[ "$cmd" =~ ^UNI$ ]]; then
        state=$units

    elif [[ "$cmd" =~ ^UNI,[123]$ ]]; then
        units=${cmd#UNI,}
        state=$units

    elif [[ "$cmd" =~ ^BAU$ ]]; then
        state=$baud

    elif [[ "$cmd" =~ ^PUC$ ]]; then
        state=$puc

    elif [[ "$cmd" =~ ^PUC,[01]$ ]]; then
        puc=${cmd#PUC,}
        state=$puc

    elif [[ "$cmd" =~ ^SAV$ ]]; then
        state=$sav

    elif [[ "$cmd" =~ ^SAV,[012]$ ]]; then
        sav=${cmd#SAV,}
        state=$sav

    else
        echo "unknown command '$cmd'" 1>&2
        echo -e $NAK
        return
    fi

    echo $ACK

    echo "command $cmd" 1>&2;
}


while true; do
	read -r cmd;
	test -z "${cmd}" && exit;
	cmd_handle $cmd; 
done

