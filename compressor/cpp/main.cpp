#include <QtCore>
#include <QString>
#include <QDebug>

#include <fstream>
#include <streambuf>

QStringList load_dict(const QString & path)
{
	QDir dir = path;
	
	if(!dir.exists())
	{
		qDebug() << "ERROR:DICT:DIR";
		exit(EXIT_FAILURE);
	}
	
	QStringList files = dir.entryList(QDir::Files);
	
	if(files.size() < 1)
	{
		qDebug() << "ERROR:DICT:FILES";
		exit(EXIT_FAILURE);
	}
	
	for(int i=0; i<files.size();   i++)
	for(int j=0; j<files.size()-1; j++)
	{
		if(files[j].toInt() > files[j+1].toInt())
		swap(files[j], files[j+1]);
	}
	
	for(int i=0; i<files.size(); i++)
	{
		QString name = path + "/" + files[i];
		QFile file(name);
		file.open(QFile::ReadOnly|QFile::Text);
		QTextStream stream(&file);
		files[i] = stream.readAll();
	}
	
	return files;
}

QStringList copy_files(int argc, char * argv[])
{
	QStringList files;
	QString path = argv[2];
	QDir    dir  = path;
	
	if(!dir.exists())
	{
		qDebug() << "ERROR:COPY:DIR";
		exit(EXIT_FAILURE);
	}
	
	for(int i=3; i<argc; i++)
	{
		QString file = argv[i];
		
		if(!QFileInfo(file).exists())
			continue;
		
		QString name = QFileInfo(file).fileName();
		QString next = path + "/" + name;
		
		if(QFileInfo(next).exists())
			QFile(next).remove();
		
		QFile::copy(file, next);
		files << next;
	}
	
	return files;
}

int main(int argc, char * argv[])
{
	if(argc < 4)
	{
		qDebug() << "ERROR: ARGS";
		exit(EXIT_FAILURE);
	}
	
	QStringList dict  = load_dict(argv[1]);
	QStringList paths = copy_files(argc, argv);
	QString pattern  = "<[|dict(%1)|]>";
	
	for(auto & path : paths)
	{
		qDebug() << "Compress: " << path;
		QFile inFile(path);
		inFile.open(QFile::ReadOnly|QFile::Text);
		QTextStream inStream(&inFile);
		QString buff = inStream.readAll();
		inFile.close();
		
		for(int i=0; i<dict.size(); i++)
		{
			QString pat = QString(pattern).arg(QString::number(i+1));
			buff = buff.replace(dict[i], pat);
		}
		
		QFile outFile(path);
		outFile.open(QIODevice::WriteOnly|QFile::Text);
		QTextStream outStream(&outFile);
		outStream << buff;
		outFile.close();
	}
	
	return 0;
}

