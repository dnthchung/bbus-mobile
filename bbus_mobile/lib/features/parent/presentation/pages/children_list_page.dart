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
                        studentId: child.id ?? 'N/A',
                        busId: child.busId ?? 'Unknown',
                        name: child.name ?? 'No Name',
                        dob: child.dob ?? 'No Age Info',
                        gender: child.gender,
                        avatar: child.avatar ?? '',
                        address: child.address ?? '',
                        checkpointId: child.checkpointId ?? '',
                        checkpointName: child.checkpointName ?? '',
                        status: child.status ?? 'Unknown',
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
          } else if (state is ChildrenListLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
