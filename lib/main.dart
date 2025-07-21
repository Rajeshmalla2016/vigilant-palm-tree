import 'package:flutter/material.dart';
import 'package:msebeccs/Body%20Members/Director%20Body/directorbody.dart';
import 'package:msebeccs/Body%20Members/Loan%20Committee/loancommittee.dart';
import 'package:msebeccs/Downloads/downloads1.dart';
import 'package:msebeccs/EMI%20Calculator/emicalculator.dart';
import 'package:msebeccs/Gallery/Annual%20General%20Meeting/annualgeneralmeeting.dart';
import 'package:msebeccs/Gallery/Retirements%20Felicitation/retirementsfelicitation.dart';
import 'package:msebeccs/Gallery/StudentsAward/studentsaward.dart';
import 'package:msebeccs/MOM/meetings.dart';
import 'package:msebeccs/Registeration_page/RegistrationPage.dart';
import 'Contact Us/contactus.dart';
import 'Log_IN/LogInSplashScreen.dart';
import 'Members/members.dart';
import 'Loan/loan.dart';
import 'Gallery/gallery.dart';
import 'Body Members/bodyMembers.dart';
import 'AboutUs/aboutus.dart';
import 'Deposit/deposit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentindex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(onPressed: (){}, icon: Icon(Icons.account_circle,size: 30,color: Colors.white,)),
        actions: [Container(
            margin: EdgeInsets.only(right: 30),
            child: Text('Add Address', style: TextStyle(color:Colors.white,fontSize: 18,fontWeight: FontWeight.w700),)),
          IconButton(onPressed: (){},
              icon:Icon(Icons.notifications,size: 30,color: Colors.white,)),
          IconButton(onPressed: (){},
              icon:Icon(Icons.quiz_outlined,size: 30,color: Colors.white,)),
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body:Stack(
        children: [
          Positioned.fill(
            //top: 30,
            child:Image.asset('assets/images/ffbg.png',
                //fit:BoxFit.cover,
              ) ,
          ),
          SingleChildScrollView(
          child: Column(
            children: [
              /* MSEB LOBO , NAME ICON DETAILS */
              Container(
               // color: Colors.white,
                height: 90,
                margin: EdgeInsets.only(top: 10,left: 10),
                child: Row(
                  children: [
                    Image.asset('assets/images/finalLogo.png',),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 7),
                        child: Text('M.S.E.B. EngineersCo - Op.Credit Society Ltd.Nagpur',
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800,color: Colors.deepPurple),),
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),

              /* GALLERY , MEMBERS , BODY MEMBERS */
              Container(
                height: 80,
                width: double.infinity,
                  color: Colors.white54,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Gallery()));
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor:Colors.white,
                              backgroundColor: Colors.deepPurple,
                            ),
                            label: Text('Gallery',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700),),
                            icon: Icon(Icons.image_outlined,size: 30,color: Colors.white,),
                          ),

                          SizedBox(width: 12,),

                          ElevatedButton.icon(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Members()));
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,backgroundColor: Colors.deepPurple
                            ),
                            label: Text('Members',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700),),
                            icon: Icon(Icons.people_alt_outlined,size: 30,color: Colors.white,),),

                          SizedBox(width: 12,),

                          ElevatedButton.icon(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>BodyMembers()));
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,backgroundColor: Colors.deepPurple
                            ),
                            label: Text('   Body\nMembers',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700),),
                            icon: SizedBox(
                                height: 20,
                                width: 20,
                                child: Image.asset('assets/icons/people.png',)),),
                          //icon: Icon(,size: 30,color: Colors.white,),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 40,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /* DIRECTOR BODY */
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DirectorBody()),
                      );
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset('assets/icons/directorbody.png'),
                        ),
                        SizedBox(height: 4), // optional spacing
                        Text(
                          'Director\n Body',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /* LOAN COMMITEE */
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoanCommittee()),
                      );
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 45,
                          width: 45,
                          child: Image.asset('assets/icons/commitee.png'),
                        ),
                        SizedBox(height: 4), // small spacing
                        Text(
                          'Loan\nCommittee',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /* AGM GALLERY */
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Annualgeneralmeeting()));
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset('assets/icons/gallery.png'),
                        ),
                        Text(
                          '  AGM\n  Gallery',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 45,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /* LOGIN  */
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset('assets/icons/login.png'),
                        ),
                        Text(
                          'LogIn',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /* REGISTERATION  */
                  GestureDetector(
                    onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationForm()));
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset('assets/icons/registeration.png'),
                        ),
                        Text(
                          'Registeration',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /* DOWNLOAD  */
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Downloads1()));
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset('assets/icons/download.png'),
                        ),
                        Text(
                          'Download',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),

              SizedBox(
                height: 45,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /* EMI CALCULATOR */
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EMICalculatorApp()));
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset('assets/icons/emical.png'),
                        ),
                        Text(
                          '     EMI\n    Calculator',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  /* RETIREMENT FELICIATION */
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RetirementsFelicitation()));
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset('assets/icons/retirementfel.png'),
                        ),
                        Text(
                          'Retirements\n Felicitation',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  /* STUDENTS AWARD */
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StudentsAward()));
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset('assets/icons/studentaward.png'),
                        ),
                        Text(
                          'Students\n Award',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 45,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /* LOAN ICON */
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Loan()));
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 45,
                          width: 45,
                          child: Image.asset('assets/icons/mainloan.png'),
                        ),
                        Text(
                          'Loan',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),

                  /* DEPOSIT ICON */
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Deposit()));
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset('assets/icons/deposit.png'),
                        ),
                        Text(
                          'Deposit',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 70,
        currentIndex: currentindex,
        onTap: (index) {
          setState(() {
            currentindex = index;
            switch(index) {
              case 0:
                Navigator.push(context, MaterialPageRoute(builder: (_) => Meeting()));
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (_) => AboutUs()));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (_) => ContactUs()));
                break;
            }
          });
        },
        backgroundColor: Colors.deepPurple,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset('assets/icons/meet.png', height: 20, width: 20),
              label: 'M.O.M'),
          BottomNavigationBarItem(
              icon: Image.asset('assets/icons/about_us.png', height: 20, width: 20),
              label: 'About'),
          BottomNavigationBarItem(
              icon: Image.asset('assets/icons/contact_us.png', height: 20, width: 20),
              label: 'Contact Us'),
        ],
      ),
    );
  }
}












