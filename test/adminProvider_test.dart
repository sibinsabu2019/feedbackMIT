import 'package:feedback/provider/adminProvider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("these testing is for clearing the all data from the admin provider class", () {
    test("same as the above", () {
    AdminProvider admin=AdminProvider();
    admin.DepartmentList=["mech","cs"];
    admin.Error="error occured";
    admin.selectedRole="teacher";

    admin.clearData();
    
    expect(admin.DepartmentList, isEmpty);
    expect(admin.Error,isNull);
    expect(admin.selectedRole,isNull);


    });
   });
}