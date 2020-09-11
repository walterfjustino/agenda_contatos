import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";


class ContactHelper{

  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;
  ContactHelper.internal();

  Database _db;   //CRIA O BANCO DE DADOS

  // ignore: missing_return
  Future <Database> get db async {         // INICIA O BANCO DE DADOS
    if(_db != null){
      return _db;
    } else{
      _db = await initDb();
      return _db;
    }
  }

  Future <Database> initDb() async {   // FUNÇÃO QUE CRIA O BANCO DE DADOS E DEFINE LOCAL ONDE É CRIADO
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contacts2.db"); // LOCAL DO DATABASE

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
        "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)"
      );
    });
  }

  Future <Contact> saveContact(Contact contact) async {   // FUNÇAO SALVA CONTATO
    Database dbContact = await db;  //CONECTA COM O BANCO DE DADOS
   contact.id = await dbContact.insert(contactTable, contact.toMap());
   return contact;
  }

  Future <Contact> getContact(int id) async { // FUNÇAO RETORNA UM CONTATO
    Database dbContact = await db;   //CONECTA COM O BANCO DE DADOS
    List<Map> maps = await dbContact.query(contactTable,
    columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
    where: "$idColumn = ?",
    whereArgs: [id]);
    if(maps.length > 0){
      return Contact.fromMap(maps.first);
    } else{
      return null;
    }
  }

  Future <int> deleteContact(int id) async {  // FUNÇAO DELETA CONTATO
    Database dbContact = await db;   //CONECTA COM O BANCO DE DADOS
   return await dbContact.delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future <int> updateContact(Contact contact) async {   //FUNÇÃO ATUALIZA O CONTATO
    Database dbContact = await db;   //CONECTA COM O BANCO DE DADOS
    return await dbContact.update(contactTable, contact.toMap(), where: "$idColumn = ?", whereArgs: [contact.id]);
  }

  Future <List> getAllContacts() async {   // FUNÇÃO RETORNA LISTA DE CONTATOS
    Database dbContact = await db;   //CONECTA COM O BANCO DE DADOS
    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContact = List();
    for(Map m in listMap){
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

 Future <int> getNumber() async {  // FUNÇÃO RETORNA A QUANTIDADE DE CONTATOS DA LISTA
    Database dbContact = await db;   //CONECTA COM O BANCO DE DADOS
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

   Future close() async { // FECHA O BANCO DE DADOS
      Database dbContact = await db;
      dbContact.close();
    }
}

class Contact {

  int id;
  String name;
  String email;
  String phone;
  String img; // LOCAL ONDE A IMAGEM É ARMAZENADA

  Contact(); // CONSTRUTOR VAZIO

  //TRANSFORMA OS DADOS DO MAP EM CONTATO
  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

//TRANSFORMA OS DADOS DO CONTATO EM UM MAP

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString(){
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img )";
}


}