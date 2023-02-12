import 'package:amazon_clone/shard/constants/global_variables.dart';
import 'package:amazon_clone/shard/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import '../../../shard/common/widget/widget.dart';
import '../../../shard/cubit/stats.dart';
import '../../../shard/network/local/cache_helper.dart';
import '../../admin/screens/admin_layout.dart';
import '../../home/screens/home_layout.dart';
import '../serveses/serveses.dart';
// ignore: use_key_in_widget_constructors
class AuthScreen extends StatelessWidget {
  var signUpFormKey = GlobalKey<FormState>();
  var signInFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AmazonCubit(),
        child:
            BlocConsumer<AmazonCubit, AmazonStates>(listener: (context, state) {
          if (state is AmazonSignUpSucccessState) {
            if (state.userMoDel?.status == true) {
              // print(state.userMoDel?.data!.token);
              ShowToast(
                  text: state.userMoDel!.message.toString(), state: ToastStates.SUCCESS);
            } else {
              ShowToast(
                  text: state.userMoDel!.message.toString(), state: ToastStates.ERROR);
            }
          }
          if (state is AmazonSignInSucccessState) {
            if (state.userMoDel?.status == true) {
              print(state.userMoDel?.data!.token);
              ShowToast(text: "SUCCESS SinIn", state: ToastStates.SUCCESS);
              CacheHelper.saveData(
                      key: 'token', value: state.userMoDel?.data!.token)
                  .then((value) {
                    if(state.userMoDel?.data?.type!='user')
                     return navigatAndFinsh(context, AdminLayout() );

                    return navigatAndFinsh(
                      context, HomeLayout(state.userMoDel?.data!.token ));
                  }) 
                  ;
              CacheHelper.saveData(
                  key: 'id', value: state.userMoDel?.data!.id);

              CacheHelper.saveData(
                  key: 'email', value: state.userMoDel?.data!.email);
            } else {
              ShowToast(
                  text: state.userMoDel!.message.toString(), state: ToastStates.ERROR);
            }
          }
        }, builder: (context, state) {
          var cubit = AmazonCubit.get(context);
          return Scaffold(
            // appBar: AppBar(),
            backgroundColor: GlobalVariables.greyBackgroundCOlor,
            body: SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    'Welcom',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  ListTile(
                    tileColor: cubit.auth == Auth.signup
                        ? GlobalVariables.backgroundColor
                        : GlobalVariables.greyBackgroundCOlor,
                    title: const Text(
                      'Create an acount',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    leading: Radio(
                      value: Auth.signup,
                      activeColor: GlobalVariables.secondaryColor,
                      groupValue: cubit.auth,
                      onChanged: (Auth? val) {
                        cubit.changeAuth(val);
                      },
                    ),
                  ),
                  if (cubit.auth == Auth.signup)
                    Container(
                      color: GlobalVariables.backgroundColor,
                      padding: const EdgeInsets.all(8),
                      child: Form(
                        key: signUpFormKey,
                        child: Column(
                          children: [
                            costomFormField(
                              Controller: cubit.nameController,
                              type: TextInputType.emailAddress,
                              prefix: Icons.contacts_outlined,
                              hintText: "Name",
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'please enter your name ';
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            costomFormField(
                              Controller: cubit.emailController,
                              type: TextInputType.emailAddress,
                              prefix: Icons.email,
                              hintText: "Email",
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'please enter your email address ';
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            costomFormField(
                              Controller: cubit.passwordController,
                              type: TextInputType.visiblePassword,
                              ispass: cubit.ispass,
                              prefix: Icons.lock_outline,
                              hintText: "Password",
                              suffix: AmazonCubit.get(context).suffix,
                              suffixpressed: () {
                                AmazonCubit.get(context)
                                    .changePasssVisibility();
                              },
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'please enter your Password address ';
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ConditionalBuilder(
                              condition: state is! AmazonSignUpLodingState,
                              builder: (context) => defaultTextButton(
                                onPress: () {
                                  //cubit.users();
                                  if (signUpFormKey.currentState!.validate()) {
                                    AmazonCubit.get(context).userRegister(
                                        name: cubit.nameController.text,
                                        email: cubit.emailController.text,
                                        password:
                                            cubit.passwordController.text);
                                  }
                                },
                                text: " Sign Up",
                              ),
                              fallback: (context) => const Center(
                                  child: CircularProgressIndicator()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ListTile(
                    tileColor: cubit.auth == Auth.signin
                        ? GlobalVariables.backgroundColor
                        : GlobalVariables.greyBackgroundCOlor,
                    title: const Text(
                      'Sign-In.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    leading: Radio(
                      value: Auth.signin,
                      activeColor: GlobalVariables.secondaryColor,
                      groupValue: cubit.auth,
                      onChanged: (Auth? val) {
                        cubit.changeAuth(val);
                      },
                    ),
                  ),
                  if (cubit.auth == Auth.signin)
                    Container(
                      color: GlobalVariables.backgroundColor,
                      padding: const EdgeInsets.all(8),
                      child: Form(
                        key: signInFormKey,
                        child: Column(
                          children: [
                            costomFormField(
                              Controller: cubit.emailController,
                              type: TextInputType.emailAddress,
                              prefix: Icons.email,
                              hintText: "Email",
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'please enter your email address ';
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            costomFormField(
                              Controller: cubit.passwordController,
                              type: TextInputType.visiblePassword,
                              ispass: cubit.ispass,
                              prefix: Icons.lock_outline,
                              hintText: "Password",
                              suffix: AmazonCubit.get(context).suffix,
                              suffixpressed: () {
                                AmazonCubit.get(context)
                                    .changePasssVisibility();
                              },
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'please enter your Password address ';
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ConditionalBuilder(
                              condition: state is! AmazonSignInLodingState,
                              builder: (context) => defaultTextButton(
                                onPress: () {
                                  if (signInFormKey.currentState!.validate()) {
                                    AmazonCubit.get(context).userSignIn(
                                        email: cubit.emailController.text,
                                        password:
                                            cubit.passwordController.text);
                                  }
                                },
                                text: " Sign In",
                              ),
                              fallback: (context) => const Center(
                                  child: CircularProgressIndicator()),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            )),
          );
        }));
  }
}
