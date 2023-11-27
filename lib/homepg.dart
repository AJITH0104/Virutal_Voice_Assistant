import 'package:aiassistant2/featurebox.dart';
import 'package:aiassistant2/openaiservice.dart';
import 'package:aiassistant2/palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
class homepg extends StatefulWidget {
  const homepg({super.key});

  @override
  State<homepg> createState() => _homepgState();
}

class _homepgState extends State<homepg> {
  final openaiservice opaiser=openaiservice();
  final flutterTts = FlutterTts();
  String? gencont,imgurl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initspeechtotext();
    inittexttospeech();
  }

  Future<void> inittexttospeech() async{
    await flutterTts.setSharedInstance(true);
    setState(() {
    });
  }

  Future<void> sysspk(String cont) async{
    await flutterTts.speak(cont);
  }



  final speechtotext= SpeechToText();
  Future<void> initspeechtotext() async{
    await speechtotext.initialize();
    setState(() {

    });
  }

  Future<void> startListening() async {
    await speechtotext.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    await speechtotext.stop();
    setState(() {});
  }
 String lastwords='';
  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastwords = result.recognizedWords;
    });
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechtotext.stop();
    flutterTts.stop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if(await speechtotext.hasPermission && speechtotext.isNotListening){
           await startListening();
          }else if(speechtotext.isListening){
            final speech=await opaiser.isartpromptapi(lastwords);
            if(speech.contains('https')){
              imgurl=speech;
              gencont=null;
              setState(() {

              });
            }else{
              imgurl=null;
              gencont=speech;
              await sysspk(speech);
              setState(() {

              });
            }

            await stopListening();
          }else{
            initspeechtotext();
          }

        },
        child: const Icon(Icons.mic),
      ),
      appBar: AppBar(
        title: const Text('AI Assistant'),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                        color: pallete.assistantCircleColor,
                        shape: BoxShape.circle),
                  ),
                ),
                Container(
                  height: 123,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('images/virtualAssistant.png'))),
                ),
              ],
            ),
            // chat bubble
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(top: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: pallete.borderColor),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                 gencont==null? "Good morning what task can i do for you?":gencont.toString(),
                  style: GoogleFonts.playfairDisplay(
                      color: pallete.mainFontColor, fontSize: gencont==null?25:18),
                ),
              ),
            ),
            if(imgurl!=null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(borderRadius:BorderRadius.circular(20),child: Image.network(imgurl.toString())),
              ),
            Visibility(
              visible: gencont==null&& imgurl==null,
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(left: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Here are a few features',
                    style: GoogleFonts.playfairDisplay(
                        color: pallete.mainFontColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            //features list
            Visibility(
              visible: gencont==null&& imgurl==null,
              child: const Column(
                children: [
                  featurebox(pallete.firstSuggestionBoxColor, 'Chat GPT',
                      'A smarter way to stay organised and informed with Chat Gpt'),
                  featurebox(pallete.secondSuggestionBoxColor, 'Dall-e',
                      'Get inspired and stay creative with your personal assistant powered by Dall-e'),
                  featurebox(
                      pallete.thirdSuggestionBoxColor,
                      'Smart Assistant Voice',
                      'Get the best of both worlds with a voice assistant powered by Dall-e and GPT')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
