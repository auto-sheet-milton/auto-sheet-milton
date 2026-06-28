import 'package:flutter/material.dart';

void main() {
  runApp(MiltonAutoSheetApp());
}

class MiltonAutoSheetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Milton Auto Sheet',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: SalarySheetScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Employee {
  String name = '';
  String designation = '';
  double basic = 0;
  double growthPercent = 0;
  int fridayDays = 0;

  double growthAmount() => basic * growthPercent / 100;
  double fridayAmount(double dailyRate) => fridayDays * dailyRate;
  double grandSalary(double dailyRate) => basic + growthAmount() + fridayAmount(dailyRate);
}

class SalarySheetScreen extends StatefulWidget {
  @override
  _SalarySheetScreenState createState() => _SalarySheetScreenState();
}

class _SalarySheetScreenState extends State<SalarySheetScreen> {
  List<Employee> employees = [Employee()];
  double dailyRate = 600;

  void addRow() {
    setState(() {
      employees.add(Employee());
    });
  }

  void removeRow(int index) {
    if (employees.length > 1) {
      setState(() {
        employees.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('নূন্যতম একটি সারি থাকতে হবে!')),
      );
    }
  }

  double getTotalPayout() {
    return employees.fold(0, (sum, emp) => sum + emp.grandSalary(dailyRate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Milton Auto Sheet', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.indigo,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('ডেইলি রেট সেট করো'),
                  content: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'যেমন: 600',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => setState(() => dailyRate = double.tryParse(v) ?? 600),
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: Text('OK'))
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // টেবিল হেডার
          Container(
            color: Colors.indigo[50],
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              children: [
                Expanded(flex: 1, child: Text('SL', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                Expanded(flex: 3, child: Text('নাম', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                Expanded(flex: 2, child: Text('বেসিক', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                Expanded(flex: 2, child: Text('গ্রোথ%', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                Expanded(flex: 2, child: Text('শুক্র', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                Expanded(flex: 3, child: Text('মোট টাকা', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
                Container(width: 40), // অ্যাকশন বাটনের জন্য ফাঁকা জায়গা
              ],
            ),
          ),
          // টেবিল বডি
          Expanded(
            child: ListView.builder(
              itemCount: employees.length,
              itemBuilder: (ctx, i) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        // সিরিয়াল
                        Expanded(flex: 1, child: Center(child: Text('${i + 1}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)))),
                        
                        // নাম ও ডেজিগনেশন (একত্রে নিচে নিচে রাখা হয়েছে জায়গা বাঁচানোর জন্য)
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(hintText: 'নাম', border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.all(4)),
                                onChanged: (v) => employees[i].name = v,
                              ),
                              TextField(
                                decoration: InputDecoration(hintText: 'পদবী', border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.all(4)),
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                onChanged: (v) => employees[i].designation = v,
                              ),
                            ],
                          ),
                        ),
                        
                        // বেসিক স্যালারি
                        Expanded(
                          flex: 2,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(hintText: '০', border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!)), isDense: true),
                            onChanged: (v) => setState(() => employees[i].basic = double.tryParse(v) ?? 0),
                          ),
                        ),
                        SizedBox(width: 6),
                        
                        // গ্রোথ পারসেন্ট (স্লাইডারের বদলে ফিল্ড করা হয়েছে)
                        Expanded(
                          flex: 2,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(hintText: '০%', border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!)), isDense: true),
                            onChanged: (v) => setState(() => employees[i].growthPercent = double.tryParse(v) ?? 0),
                          ),
                        ),
                        SizedBox(width: 6),
                        
                        // শুক্রবারের দিন সংখ্যা
                        Expanded(
                          flex: 2,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(hintText: ' দিন', border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!)), isDense: true),
                            onChanged: (v) => setState(() => employees[i].fridayDays = int.tryParse(v) ?? 0),
                          ),
                        ),
                        
                        // গ্র্যান্ড টোটাল
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '৳${employees[i].grandSalary(dailyRate).toStringAsFixed(0)}',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700], fontSize: 15),
                            ),
                          ),
                        ),
                        
                        // ডিলিট বাটন
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red[400], size: 20),
                          onPressed: () => removeRow(i),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // নিচে সর্বমোট হিসাবের সামারি প্যানেল
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ডেইলি রেট: ৳${dailyRate.toStringAsFixed(0)}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    SizedBox(height: 2),
                    Text('মোট কর্মচারী: ${employees.length} জন', style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('সর্বমোট পে-আউট', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    Text(
                      '৳${getTotalPayout().toStringAsFixed(0)}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0), // সামারি প্যানেলের উপরে রাখার জন্য
        child: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.indigo,
          onPressed: addRow,
          tooltip: 'নতুন কর্মচারী যোগ করুন',
        ),
      ),
    );
  }
}
