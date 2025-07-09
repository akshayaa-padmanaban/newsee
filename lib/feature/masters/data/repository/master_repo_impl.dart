import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/auth_failure.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/api/http_connection_failure.dart';
import 'package:newsee/core/api/http_exception_parser.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/masters/data/datasource/masters_remote_datasource.dart';
import 'package:newsee/feature/masters/data/repository/geography_parser_impl.dart';
import 'package:newsee/feature/masters/data/repository/lov_parser_impl.dart';
import 'package:newsee/feature/masters/data/repository/product_master_parser_impl.dart';
import 'package:newsee/feature/masters/data/repository/product_parser_impl.dart';
import 'package:newsee/feature/masters/data/repository/productschema_parser_impl.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/modal/master_request.dart';
import 'package:newsee/feature/masters/domain/modal/master_response.dart';
import 'package:newsee/feature/masters/domain/modal/master_types.dart';
import 'package:newsee/feature/masters/domain/modal/master_version.dart';
import 'package:newsee/feature/masters/domain/modal/product.dart';
import 'package:newsee/feature/masters/domain/modal/product_master.dart';
import 'package:newsee/feature/masters/domain/modal/productschema.dart';
import 'package:newsee/feature/masters/domain/modal/statecitymaster.dart';
import 'package:newsee/feature/masters/domain/repository/audit_logger.dart';
import 'package:newsee/feature/masters/domain/repository/geographymaster_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/lov_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/master_repo.dart';
import 'package:newsee/feature/masters/domain/repository/masterversion_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/product_schema_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/products_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/products_master_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/statecity_master_crud_repo.dart';
import 'package:sqflite/sqlite_api.dart';

class MasterRepoImpl extends MasterRepo {
  @override
  Future<AsyncResponseHandler<Failure, MasterResponse>> downloadMaster({
    required MasterRequest request,
  }) async {
    /* initializing types required for AsyncResponseHandler Object */

    MasterTypes masterTypes = MasterTypes.lov;
    Database db = await DBConfig().database;
    MasterResponse masterResponse = MasterResponse(
      master: [],
      masterType: masterTypes,
    );
    AuthFailure failure = AuthFailure(message: "");

    try {
      switch (request.setupTypeOfMaster) {
        case ApiConstants.master_key_lov:
          masterTypes = MasterTypes.lov;

          Response response;
          try {
            response = await MastersRemoteDatasource(
              dio: ApiClient().getDio(),
            ).downloadMaster(request);

            await logMasterAudit(
              db: db,
              masterName: 'lov',
              stage: AuditLogger.apiRequest,
            );
          } on DioException catch (e) {
            await logMasterAudit(
              db: db,
              masterName: 'lov',
              stage: AuditLogger.apiRequest,
              error: e.message,
            );
            rethrow;
          }

          final String versionFromResponse = response.data['version'];
          final String masterNameFromResponse = ApiConstants.master_key_lov;

          List<Lov> lovList = LovParserImpl().parseResponse(response);
          if (lovList.isNotEmpty) {
            Iterator<Lov> it = lovList.iterator;
            LovCrudRepo lovCrudRepo = LovCrudRepo(db);
            while (it.moveNext()) {
              lovCrudRepo.save(it.current);
            }

            await logMasterAudit(
              db: db,
              masterName: 'lov',
              stage: AuditLogger.tableInsert,
              rowCount: lovList.length,
            );

            await updateMasterVersion(
              db,
              masterNameFromResponse,
              versionFromResponse,
              'success',
            );

            masterResponse = MasterResponse(
              master: lovList,
              masterType: MasterTypes.products,
            );
          } else {
            var errorMessage = response.data['errorDesc'];

            await logMasterAudit(
              db: db,
              masterName: 'lov',
              stage: AuditLogger.tableInsert,
              error: errorMessage,
            );

            await updateMasterVersion(
              db,
              masterNameFromResponse,
              versionFromResponse,
              'failure',
            );

            failure = AuthFailure(message: errorMessage);
          }

        case ApiConstants.master_key_products:
          masterTypes = MasterTypes.products;

          Response response;
          try {
            response = await MastersRemoteDatasource(
              dio: ApiClient().getDio(),
            ).downloadMaster(request);

            await logMasterAudit(
              db: db,
              masterName: 'products',
              stage: AuditLogger.apiRequest,
            );
          } on DioException catch (e) {
            await logMasterAudit(
              db: db,
              masterName: 'products',
              stage: AuditLogger.apiRequest,
              error: e.message,
            );
            rethrow;
          }

          final String versionFromResponse = response.data['version'];
          final String masterNameFromResponse =
              ApiConstants.master_key_products;

          List<Product> productsList =
              ProductParserImpl().parseResponse(response);
          List<ProductMaster> productmasterList =
              ProductMasterParserImpl().parseResponse(response);

          if (productsList.isNotEmpty) {
            ProductsCrudRepo productsCrudRepo = ProductsCrudRepo(db);
            for (final p in productsList) {
              await productsCrudRepo.save(p);
            }
          }

          if (productmasterList.isNotEmpty) {
            ProductMasterCrudRepo pmRepo = ProductMasterCrudRepo(db);
            for (final pm in productmasterList) {
              await pmRepo.save(pm);
            }
          }

          if (productsList.isNotEmpty || productmasterList.isNotEmpty) {

            await logMasterAudit(
              db: db,
              masterName: 'products',
              stage: AuditLogger.tableInsert,
              rowCount: productsList.length,
            );
            await logMasterAudit(
              db: db,
              masterName: 'productmaster',
              stage: AuditLogger.tableInsert,
              rowCount: productmasterList.length,
            );

            await updateMasterVersion(
              db,
              masterNameFromResponse,
              versionFromResponse,
              'success',
            );

            masterResponse = MasterResponse(
              master: productmasterList,
              masterType: MasterTypes.productschema,
            );
          } else {
            var errorMessage = response.data['errorDesc'] ?? 'Empty list';

            await logMasterAudit(
              db: db,
              masterName: 'products',
              stage: AuditLogger.tableInsert,
              error: errorMessage,
            );

            await updateMasterVersion(
              db,
              masterNameFromResponse,
              versionFromResponse,
              'failure',
            );

            failure = AuthFailure(message: errorMessage);
          }

        case ApiConstants.master_key_productschema:
          masterTypes = MasterTypes.productschema;

          Response response;
          try {
            response = await MastersRemoteDatasource(
              dio: ApiClient().getDio(),
            ).downloadMaster(request);

            await logMasterAudit(
              db: db,
              masterName: 'productschema',
              stage: AuditLogger.apiRequest,
            );
          } on DioException catch (e) {
            await logMasterAudit(
              db: db,
              masterName: 'productschema',
              stage: AuditLogger.apiRequest,
              error: e.message,
            );
            rethrow;
          }

          List<ProductSchema> productSchemaList =
              ProductSchemaParserImpl().parseResponse(response);

          if (productSchemaList.isNotEmpty) {
            ProductSchemaCrudRepo psRepo = ProductSchemaCrudRepo(db);
            for (final ps in productSchemaList) {
              await psRepo.save(ps);
            }

            await logMasterAudit(
              db: db,
              masterName: 'productschema',
              stage: AuditLogger.tableInsert,
              rowCount: productSchemaList.length,
            );

            final String versionFromResponse = response.data['version'];
            await updateMasterVersion(
              db,
              ApiConstants.master_key_productschema,
              versionFromResponse,
              'success',
            );

            masterResponse = MasterResponse(
              master: productSchemaList,
              masterType: MasterTypes.statecitymaster,
            );
          } else {
            var errorMessage = response.data['errorDesc'] ?? 'Empty list';

            await logMasterAudit(
              db: db,
              masterName: 'productschema',
              stage: AuditLogger.tableInsert,
              error: errorMessage,
            );

            final String versionFromResponse = response.data['version'];
            await updateMasterVersion(
              db,
              ApiConstants.master_key_productschema,
              versionFromResponse,
              'failure',
            );

            failure = AuthFailure(message: errorMessage);
          }

        case ApiConstants.master_key_statecity:
          masterTypes = MasterTypes.statecitymaster;

          Response response;
          try {
            response = await MastersRemoteDatasource(
              dio: ApiClient().getDio(),
            ).downloadMaster(request);

            await logMasterAudit(
              db: db,
              masterName: 'statecitymaster',
              stage: AuditLogger.apiRequest,
            );
          } on DioException catch (e) {
            await logMasterAudit(
              db: db,
              masterName: 'statecitymaster',
              stage: AuditLogger.apiRequest,
              error: e.message,
            );
            rethrow;
          }

          List<GeographyMaster> statecityList =
              GeographyParserImpl().parseResponse(response);

          if (statecityList.isNotEmpty) {
            GeographymasterCrudRepo scRepo = GeographymasterCrudRepo(db);
            for (final sc in statecityList) {
              await scRepo.save(sc);
            }

            await logMasterAudit(
              db: db,
              masterName: 'statecitymaster',
              stage: AuditLogger.tableInsert,
              rowCount: statecityList.length,
            );

            final String versionFromResponse = response.data['version'];
            await updateMasterVersion(
              db,
              ApiConstants.master_key_statecity,
              versionFromResponse,
              'success',
            );

            masterResponse = MasterResponse(
              master: statecityList,
              masterType: MasterTypes.success,
            );
          } else {
            var errorMessage = response.data['errorDesc'] ?? 'Empty list';

            await logMasterAudit(
              db: db,
              masterName: 'statecitymaster',
              stage: AuditLogger.tableInsert,
              error: errorMessage,
            );

            final String versionFromResponse = response.data['version'];
            await updateMasterVersion(
              db,
              ApiConstants.master_key_statecity,
              versionFromResponse,
              'failure',
            );

            failure = AuthFailure(message: errorMessage);
          }

        default:
          break;
      }

      // returning AsyncResponseHandler...
      if (masterResponse.master.isNotEmpty) {
        return AsyncResponseHandler.right(masterResponse);
      } else {
        return AsyncResponseHandler.left(failure);
      }
    } on DioException catch (e) {
      HttpConnectionFailure failure =
          DioHttpExceptionParser(exception: e).parse();
      return AsyncResponseHandler.left(failure);
    }
  }

  Future<void> updateMasterVersion(
    Database db,
    String masterNameFromResponse,
    String versionFromResponse,
    String isMasterDownloadSuccess,
  ) async {
    try {
      final masterVersionCrudRepo = MasterversionCrudRepo(db);

      await masterVersionCrudRepo.save(
        MasterVersion(
          mastername: masterNameFromResponse,
          version: versionFromResponse,
          status: isMasterDownloadSuccess,
        ),
      );
    } catch (e) {
      print("Error inserting masterversion : $e");
    }
  }

  // now lov is a List contains Map<String,dynamic>
}
