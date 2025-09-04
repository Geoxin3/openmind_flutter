class   Apibaseurl {
  //base url for all
  //for emultaor 10.0.2.2:8000
  //for web 127.0.0.1:8000
  //for runnning on real device 192.168.1.74:8000(ipv4) of pc
  //and in this case run the djnago like this
  //python manage.py runserver 0.0.0.0:8000
  //in django while running the server for emulator use this 
  //(python manage.py runserver 0.0.0.0:8000)
  static const String baseUrl = 'http://192.168.178.53:8000/api/';
  static const String baseUrl2 = 'http://192.168.178.53:8000';
  static const String baseUrl3 = '192.168.178.53:8000';
}