%dw 2.0 
output application/json 
import * from dw::core::Objects

var newData = vars.newData default {}
var oldData = vars.oldData default {}

fun getModificationDifferences(newVal,oldVal) =
 (entrySet(newVal) map {
    ( ($).key as String) : iterateData(($).value,oldVal[($).key as String])
 }) reduce((val,acc={}) -> acc ++ val)
 
 
fun iterateData(newVal,oldVal) = 
    oldVal match {
        case is Object -> newVal mapObject(v,k,i) ->{
            (k) : iterateData((v),oldVal[k as String])
        }
        case is Array -> newVal map (v,i) -> iterateData((v),oldVal[(i)])
        else -> (if(newVal != oldVal){
        newValue :newVal,
        oldValue : oldVal
    } else newVal)
}
    

--- 
getModificationDifferences(newData,oldData)
