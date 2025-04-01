// @GenerateMocks([http.Client])
// void main() {
//   late DashBoard dashboard;
//   late MockClient mockClient;

//   setUp(() {
//     dashboard = DashBoard();
//     mockClient = MockClient();
//   });

//   group('API Methods Tests', () {
//     final userData = {
//       'firstName': 'John',
//       'email': 'john@example.com',
//       'phone': '1234567890'
//     };
//     final jsonResponse = json.encode(userData);

//     test('getName() returns the correct name when API call is successful',
//         () async {
//       // Arrange
//       when(mockClient.get(Uri.parse('https://dummyjson.com/users/1')))
//           .thenAnswer((_) async => http.Response(jsonResponse, 200));
//       final result = await dashboard.getName();
//       expect(result, 'John');
//     });

//     test('getName() throws exception when API call fails', () async {
//       when(mockClient.get(Uri.parse('https://dummyjson.com/users/1')))
//           .thenAnswer((_) async => http.Response('Not Found', 404));
//       expect(() => dashboard.getName(), throwsException);
//     });
//     test('getEmail() returns the correct email when API call is successful',
//         () async {
//       when(mockClient.get(Uri.parse('https://dummyjson.com/users/1')))
//           .thenAnswer((_) async => http.Response(jsonResponse, 200));
//       final result = await dashboard.getEmail();
//       expect(result, 'john@example.com');
//     });

//     test('getPhone() returns the correct phone when API call is successful',
//         () async {
//       when(mockClient.get(Uri.parse('https://dummyjson.com/users/1')))
//           .thenAnswer((_) async => http.Response(jsonResponse, 200));
//       final result = await dashboard.getPhone();
//       expect(result, '1234567890');
//     });
//   });
// }
