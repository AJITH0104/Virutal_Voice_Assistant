import 'dart:convert';

import 'package:http/http.dart' as http;
import 'apikeys.dart';
class openaiservice{
final List<Map<String,String>> msg=[];
  Future<String> isartpromptapi(String prompt) async{
    try{
      final res=await http.post(Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $openaikey"
      },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "user",
              "content": "Does this message want to generate an AI picture,image,art or anything similar?$prompt . simple answer with a yes or no",
            },

          ],
        }),

      );
      print(res.body);
      if(res.statusCode==200) {
        String content = jsonDecode(
            res.body)['choices'][0]['message']['content'];
        content=content.trim();

        switch(content){
          case 'Yes':
          case 'yes':
          case 'Yes.':
          case 'yes.':
                final res=await dalleapi(prompt);
                return res;
          default:
            final res = await chatgptai(prompt);
            return res;
        }
      }
      return 'An internal error occured';//occurs when we have exhausted the api so need to prep new api
    }catch(e){
      return e.toString();
    }
  }

  Future<String> chatgptai(String prompt) async{
    msg.add({'role':'user','content':prompt});
    try{
    final res=await http.post(Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $openaikey"
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages":msg,
      }),

    );

    if(res.statusCode==200) {
      String content = jsonDecode(
          res.body)['choices'][0]['message']['content'];
      content=content.trim();
  msg.add({'role':'assistant','content':content});
  return content;

    }
    return 'An internal error occured';//occurs when we have exhausted the api so need to prep new api
  }catch(e){
    return e.toString();
  }
  }

  Future<String> dalleapi(String prompt) async{
    msg.add({'role':'user','content':prompt});
  try{
    final res=await http.post(Uri.parse(
     'https://api.openai.com/v1/images/generations'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $openaikey"
      },
      body: jsonEncode({
        "model": "dall-e-3",
        "prompt": prompt,
        "n": 1,
      }),

    );

    if(res.statusCode==200) {
      
      String imgurl = jsonDecode(
          res.body)['data'][0]['url'];
      imgurl=imgurl.trim();
      msg.add({'role':'assistant','content':imgurl});
      return imgurl;

    }
    return 'An internal error occured';//occurs when we have exhausted the api so need to prep new api
  }catch(e){
    return e.toString();
  }
  }
}