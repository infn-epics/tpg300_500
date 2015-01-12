# Usage: ncat -lkC <port_number> -c 'sh tpg300sim.sh'

ENQ="\005"
ACK="\006"

sim_state="tpg300sim_state"


function cmd_get_err {
    echo -e $ACK
    read resp;
    echo 0;
}


function cmd_get_function {
    echo -e $ACK
    read resp;
    echo 1.0E-11,1.0E-1,0;
}


function cmd_func_stat {
    echo -e $ACK
    read resp;
    echo 0,0,0,0,0,0;
}


function cmd_get_mode {
    echo -e $ACK
    read resp;
    echo 1,1,1,1;
}


function cmd_get_filter {
    echo -e $ACK
    read resp;
    echo 1,1,1,1;
}


function cmd_get_pressure {
    echo -e $ACK
    read resp;
    echo 0,1.0E-9;
}


function cmd_get_sav {
    echo -e $ACK
    read resp;
    echo 0;
}


function cmd_get_tid {
    echo -e $ACK
    read resp;
    echo 0,0,0;
}


function cmd_get_version {
    echo -e $ACK
    read resp;
    echo "-- VERSION";
}


function cmd_get_puc {
    echo -e $ACK
    read resp;
    echo 0;
}


function cmd_get_units {
    echo -e $ACK
    read resp;
    echo 1;
}


function cmd_get_baud {
    echo -e $ACK
    read resp;
    echo 0;
}



function cmd_handle {
    cmd=$(tr -dc '[[:print:]]' <<< "$1");
    
    if [[ "$cmd" =~ ^OFF$ ]]; then
        echo $cmd > $sim_state
        echo -e "\nsim $cmd\n" 1>&2
        return
    elif [[ "$cmd" =~ ^ON$ ]]; then
        echo $cmd > $sim_state
        echo -e "\nsim $cmd\n" 1>&2
        return
    fi
    
    
    if [[ "$(cat $sim_state)" =~ ^OFF$ ]]; then
        return
    fi
    
    
    if [[ "$cmd" =~ ^ERR$ ]]; then
        cmd_get_err $cmd;
    
    elif [[ "$cmd" =~ ^SP[1234AB]$ ]]; then
        cmd_get_function $cmd;
        
    elif [[ "$cmd" =~ ^SP[1234AB],*,*,[0-9]$ ]]; then
        cmd_get_function $cmd;
    
    elif [[ "$cmd" =~ ^SPS$ ]]; then
        cmd_func_stat $cmd;
    
    elif [[ "$cmd" =~ ^FIL$ ]]; then
        cmd_get_filter $cmd;
        
    elif [[ "$cmd" =~ ^FIL,[0-9],[0-9],[0-9],[0-9]$ ]]; then
        cmd_get_filter $cmd;
    
    elif [[ "$cmd" =~ ^SEN$ ]]; then
        cmd_get_mode $cmd;
        
    elif [[ "$cmd" =~ ^SEN,[0-9],[0-9],[0-9],[0-9]$ ]]; then
        cmd_get_mode $cmd;
    
    elif [[ "$cmd" =~ ^P[AB][12]$ ]]; then
        cmd_get_pressure $cmd;
    
    elif [[ "$cmd" =~ ^TID$ ]]; then
        cmd_get_tid $cmd;
        
    elif [[ "$cmd" =~ ^PNR$ ]]; then
        cmd_get_version $cmd;
    
    elif [[ "$cmd" =~ ^UNI$ ]]; then
        cmd_get_units $cmd;
    
    elif [[ "$cmd" =~ ^UNI,[123]$ ]]; then
        cmd_get_units $cmd;
    
    elif [[ "$cmd" =~ ^BAU$ ]]; then
        cmd_get_baud $cmd;
    
    elif [[ "$cmd" =~ ^PUC$ ]]; then
        cmd_get_puc $cmd;
    
    elif [[ "$cmd" =~ ^PUC,[01]$ ]]; then
        cmd_get_puc $cmd;
    
    elif [[ "$cmd" =~ ^SAV$ ]]; then
        cmd_get_sav $cmd;
    
    elif [[ "$cmd" =~ ^SAV,[012]$ ]]; then
        cmd_get_sav $cmd;
        
    else
        echo [echo] $cmd;
    fi
    
    echo "command $cmd" 1>&2
}


while true; 
    do sleep 0.001 && read cmd && cmd_handle $cmd; 
done

