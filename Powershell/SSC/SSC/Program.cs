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
