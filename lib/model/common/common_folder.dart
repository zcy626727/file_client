import 'package:file_client/model/common/common_resource.dart';

class CommonFolder extends CommonResource {
  CommonFolder({
    id,
    name,
    status,
    parentId,
    createTime,
  }) : super(
          id: id,
          name: name,
          status: status,
          parentId: parentId,
          createTime: createTime,
        );
}
