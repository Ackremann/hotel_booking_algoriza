import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hotel_booking_algoriza/core/api/end_points.dart';
import 'package:hotel_booking_algoriza/core/utils/color_manager.dart';
import 'package:hotel_booking_algoriza/core/utils/media_query_values.dart';
import 'package:hotel_booking_algoriza/core/utils/values_manager.dart';
import 'package:hotel_booking_algoriza/core/widgets/custom_input_field.dart';
import 'package:hotel_booking_algoriza/core/widgets/main_button.dart';
import 'package:hotel_booking_algoriza/features/explore/data/models/hotels_model.dart';
import 'package:hotel_booking_algoriza/features/explore/domain/usecases/get_hotels.dart';
import 'package:hotel_booking_algoriza/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../injection_container.dart';
part '../widgets/indicator_view_hotel_btn.dart';
part '../widgets/best_hotel_widgets.dart';
part '../widgets/best_deal_card.dart';

class ExploreView extends StatelessWidget {
  ExploreView({super.key});
  final PageController boardController = PageController();
  final _conSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ExploreCubit>()..getHotels(HotleParams(count: '10', page: '1')),
      child: BlocBuilder<ExploreCubit, ExploreState>(
        builder: (context, state) {
          if (state is ExploreHotelsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ExploreHotelsError) {
            return Center(
              child: Text(
                'Error',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            );
          } else if (state is ExploreHotelsLoaded) {
            final HotelsDataModel hoteldata = state.hotelsModel.hotelModel;
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Color.fromARGB(0, 36, 23, 23),
                    toolbarHeight: context.toPadding * 2,
                    pinned: true,
                    // floating: true,
                    title: CustomInputField(
                      hintText: "Where are you going ?",
                      prefixIcon: const Icon(
                        Icons.search,
                        color: ColorManager.lightGrey,
                      ),
                      inputController: _conSearch,
                    ),
                    expandedHeight: context.height / 2,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          PageView.builder(
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return BestHotelsWidget(
                                hotelData: hoteldata.data[index],
                              );
                            },
                          ),
                          IndicatorAndViewHotelBTN(
                              boardController: boardController),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Best Deals",
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          TextButton.icon(
                            style: const ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll<Color>(
                                  ColorManager.primary),
                            ),
                            onPressed: () {},
                            icon: const Text('View all'),
                            label: const Icon(Icons.arrow_forward),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: hoteldata.data.length,
                      (context, index) {
                        return BestDealWidget(
                          hotelData: hoteldata.data[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: ColorManager.error,
              ),
            );
          }
        },
      ),
    );
  }
}
