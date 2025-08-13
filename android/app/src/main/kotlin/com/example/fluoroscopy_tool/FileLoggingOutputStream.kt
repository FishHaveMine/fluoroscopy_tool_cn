import android.util.Log
import java.io.File
import java.io.OutputStream
import java.text.SimpleDateFormat
import java.util.*

class FileLoggingOutputStream(
    private val file: File,
    private val tag: String = "AppLog"
) : OutputStream() {

    private val fileOutputStream = file.outputStream().buffered()
    private val buffer = StringBuilder()
    private val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.getDefault())

    override fun write(b: Int) {
        val c = b.toChar()
        buffer.append(c)

        // 如果遇到换行符，输出一整行
        if (c == '\n') {
            val timestamp = dateFormat.format(Date())
            val message = buffer.toString().trim()
            val finalLine = "[$timestamp] $message\n"

            // 写入文件
            fileOutputStream.write(finalLine.toByteArray())

            // 输出到 Logcat
            Log.d(tag, "[$timestamp] $message")

            buffer.clear()
        }
    }

    override fun flush() {
        fileOutputStream.flush()
    }

    override fun close() {
        fileOutputStream.close()
    }
}
