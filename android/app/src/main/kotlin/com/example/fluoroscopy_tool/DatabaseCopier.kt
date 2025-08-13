import android.content.Context
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

object DatabaseCopier {

    // 复制数据库文件
    @Throws(IOException::class)
    fun copyDatabase(context: Context) {
        val assetManager = context.assets
        val inputStream = assetManager.open("config.db")
        val outFileName = context.getDatabasePath("config.db").path
        val databasesDir = File(context.getDatabasePath("config.db").path.replace("/config.db",""), "config.db")

        if (!databasesDir.exists()) {
            println("创建  ${context.getDatabasePath("config.db").path}")
            val outputStream = FileOutputStream(outFileName)

            val buffer = ByteArray(1024)
            var length: Int
            while (inputStream.read(buffer).also { length = it } > 0) {
                outputStream.write(buffer, 0, length)
            }

            outputStream.flush()
            outputStream.close()
            inputStream.close()
        } else {
            println(" ${context.getDatabasePath("config.db").path}  已存在")
        }
    }
}
