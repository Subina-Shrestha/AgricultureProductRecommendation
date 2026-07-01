using System;
using System.Net;
using System.Net.Mail;

namespace AgricultureProductRecommendation
{
    public static class EmailHelper
    {
        public static void SendEmail(string toEmail, string subject, string body)
        {
            using (MailMessage mail = new MailMessage())
            {
                mail.From = new MailAddress(SmtpConfig.From, "AgroRecSys");
                mail.To.Add(toEmail);
                mail.Subject = subject;
                mail.Body = body;
                mail.IsBodyHtml = true;

                using (SmtpClient smtp = new SmtpClient(SmtpConfig.Host, Convert.ToInt32(SmtpConfig.Port)))
                {
                    smtp.Credentials = new NetworkCredential(SmtpConfig.User, SmtpConfig.Pass);
                    smtp.EnableSsl = true;
                    smtp.Send(mail);
                }
            }
        }
    }
}