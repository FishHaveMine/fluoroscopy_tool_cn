//import java.util.*
//import javax.mail.*
//import javax.mail.internet.*
//import javax.activation.*
//import android.util.Log
//import kotlinx.coroutines.Dispatchers
//import kotlinx.coroutines.withContext
//import java.io.File
//
//object MailSender {
//
//    suspend fun sendMailWithAttachment(
//        senderEmail: String,
//        senderPassword: String,
//        recipientEmail: String,
//        subject: String,
//        body: String,
//        file: File
//    ): Boolean = withContext(Dispatchers.IO) {
//        try {
//            val props = Properties().apply {
//                put("mail.smtp.auth", "true")
//                put("mail.smtp.ssl.enable", "true")
//                put("mail.smtp.host", "smtp.163.com")
//                put("mail.smtp.port", "465")
//                put("mail.smtp.ssl.trust", "smtp.163.com")
//            }
//
//
//            val session = Session.getInstance(props, object : Authenticator() {
//                override fun getPasswordAuthentication(): PasswordAuthentication {
//                    return PasswordAuthentication(senderEmail, senderPassword)
//                }
//            })
//
//            val message = MimeMessage(session).apply {
//                setFrom(InternetAddress(senderEmail))
//                setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail))
//                setSubject(subject)
//
//                val multipart = MimeMultipart()
//
//                val bodyPart = MimeBodyPart()
//                bodyPart.setText("This is the message text")
//                multipart.addBodyPart(bodyPart)
//
//                val attachmentPart = MimeBodyPart()
//                val source = FileDataSource(file.absolutePath)
//                attachmentPart.dataHandler = DataHandler(source)
//                attachmentPart.fileName = file.name
//                multipart.addBodyPart(attachmentPart)
//
//                setContent(multipart)
//            }
//
//            Transport.send(message)
//            Log.d("MailSender", "Email sent successfully")
//            true
//        } catch (e: Exception) {
//            Log.e("MailSender", "Failed to send email: ${e.message}", e)
//            false
//        }
//    }
//}
