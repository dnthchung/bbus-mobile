import 'package:bbus_mobile/common/widgets/child_card.dart';
import 'package:bbus_mobile/features/parent/presentation/cubit/children_list/children_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChildrenListPage extends StatefulWidget {
  const ChildrenListPage({super.key});

  @override
  State<ChildrenListPage> createState() => _ChildrenListPageState();
}

class _ChildrenListPageState extends State<ChildrenListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ChildrenListCubit>().getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<ChildrenListCubit, ChildrenListState>(
        builder: (context, state) {
          if (state is ChildrenListSuccess) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.data.length,
                    itemBuilder: (context, index) {
                      final child = state.data[index];
                      return ChildCard(
                        name: child.name!,
                        age: child.dob,
                        address: child.address,
                        status: child.status,
                        isParent: true,
                      );
                    },
                  ),
                )
              ],
            );
          } else if (state is ChildrenListFailure) {
            return Center(
              child: Text('Chưa có cháu nào được đăng ký'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
