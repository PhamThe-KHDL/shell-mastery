# Solutions 09-processes

## 1.
Use `pgrep ssh` or `ps -ef | grep '[s]sh'` depending on what tools you assume.

## 2.
Capture background PIDs with `$!` and call `wait "$pid1" "$pid2"`.

## 3.
Send `kill -TERM "$pid"` first, sleep briefly, then `kill -0` to check if escalation is needed.
