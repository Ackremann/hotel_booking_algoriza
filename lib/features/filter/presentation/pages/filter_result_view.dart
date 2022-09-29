import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_booking_algoriza/config/routes/magic_router.dart';
import 'package:hotel_booking_algoriza/core/api/api_consumer.dart';
import 'package:hotel_booking_algoriza/core/utils/color_manager.dart';
import 'package:hotel_booking_algoriza/core/utils/media_query_values.dart';
import 'package:hotel_booking_algoriza/features/filter/presentation/cubit/search_cubit.dart';
import 'package:hotel_booking_algoriza/features/filter/presentation/pages/filter_view.dart';
import 'package:hotel_booking_algoriza/features/filter/presentation/widgets/map_widget.dart';
import 'package:hotel_booking_algoriza/injection_container.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../core/widgets/custom_input_field.dart';
import '../../data/models/search_hotels_model.dart';
import '../widgets/search_result_widget.dart';

class FilterResultView extends StatefulWidget {
  const FilterResultView({Key? key, required this.searchedForHotels})
      : super(key: key);
  final SearchHotelsModel searchedForHotels;
  @override
  State<FilterResultView> createState() => _FilterResultViewState();
}

class _FilterResultViewState extends State<FilterResultView> {
  final TextEditingController inputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (context) => SearchCubit(apiConsumer: sl<ApiConsumer>()),
      // sl<SearchCubit>()..getHotelBySearchValue(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.translate('explore')!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border, size: 25),
              onPressed: () {},
            ),
            BlocBuilder<SearchCubit, SearchStates>(
              builder: (context, state) {
                return state is SearchToMapstate
                    ? IconButton(
                        onPressed: (() => BlocProvider.of<SearchCubit>(context)
                            .navigateToSearch()),
                        icon: const Icon(Icons.filter_list_outlined),
                      )
                    : IconButton(
                        onPressed: (() => BlocProvider.of<SearchCubit>(context)
                            .navigateToMap()),
                        icon: const Icon(Icons.map_outlined, size: 25),
                      );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocConsumer<SearchCubit, SearchStates>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return SizedBox(
                        width: context.width / 1.35,
                        child: CustomInputField(
                          inputController: inputController,
                          hintText: 'london..',
                          onSubmitted: (value) {
                            BlocProvider.of<SearchCubit>(context)
                                .getHotelBySearchValue(value: value);
                          },
                        ),
                      );
                    },
                  ),
                  // const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorManager.primary,
                      ),
                      child: const Icon(
                        Icons.search,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('choose_date')!,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 21,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        //'23, sep - 28, oct',
                        AppLocalizations.of(context)!.translate('date')!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 2,
                    height: 70,
                    color: Colors.grey,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .translate('number_of_room')!,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 21,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '1 ${AppLocalizations.of(context)!.translate('room')!} 2 ${AppLocalizations.of(context)!.translate('people')!}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            BlocBuilder<SearchCubit, SearchStates>(
              builder: (context, state) {
                return state is SearchToMapstate
                    ? Container()
                    : Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            color: Colors.grey,
                            width: double.infinity,
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BlocBuilder<SearchCubit, SearchStates>(
                                    builder: (context, state) {
                                  return state is SearchLoadingState
                                      ? Text(
                                          '0 ${AppLocalizations.of(context)!.translate('hotel_found')!}',
                                        )
                                      : Text(
                                          '${widget.searchedForHotels.hotelModel.search.length} ${AppLocalizations.of(context)!.translate('hotel_found')!}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        );
                                }),
                                Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('filter')!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          MagicRouter.navigateAndPopAll(
                                              FiltterScreen()),
                                      icon: const Icon(
                                        Icons.filter_list_outlined,
                                        color: ColorManager.primary,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
              },
            ),
            BlocBuilder<SearchCubit, SearchStates>(
              builder: (context, state) {
                final marker = BlocProvider.of<SearchCubit>(context).markers;
                return state is SearchToMapstate
                    ? MapTest(
                        markers: marker,
                      )
                    : state is SearchLoadingState
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: widget
                                  .searchedForHotels.hotelModel.search.length,
                              itemBuilder: (context, index) =>
                                  SearchResultWidget(
                                item: widget.searchedForHotels,
                                index: index,
                              ),
                            ),
                          );
              },
            ),
          ],
        ),
        //
      ),
    );
  }
}