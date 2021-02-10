import 'package:Food_Delivery_Test/screens/allFoods.dart';
import 'package:flutter/material.dart';

class FoodCategory extends StatefulWidget {
  @override
  _FoodCategoryState createState() => _FoodCategoryState();
}

class _FoodCategoryState extends State<FoodCategory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      // margin: EdgeInsets.all(5),
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Food Category',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              // color: Colors.orange,

              height: 200,
              width: 1200,
              child: Row(
                children: [
                  _singleCardCategory('Coffee',
                      'https://firebasestorage.googleapis.com/v0/b/e-commerce-2a07e.appspot.com/o/foodCategory%2Fcoffee-cup.png?alt=media&token=051da930-cdbd-48a0-8b77-1a613f2963ef'),
                  _singleCardCategory('Pizza',
                      'https://firebasestorage.googleapis.com/v0/b/e-commerce-2a07e.appspot.com/o/foodCategory%2Fpizza.png?alt=media&token=096754e1-e8bd-4cb3-ac8f-fcd2cbd48aaf'),
                  _singleCardCategory('Burger',
                      'https://firebasestorage.googleapis.com/v0/b/e-commerce-2a07e.appspot.com/o/foodCategory%2Fburger.png?alt=media&token=b6269688-8067-4f83-8e27-3eab14e68a2b'),
                  _singleCardCategory('Noodles',
                      'https://firebasestorage.googleapis.com/v0/b/e-commerce-2a07e.appspot.com/o/foodCategory%2Fspaguetti.png?alt=media&token=993a6e59-8171-4beb-ba96-bede8f5d245a'),
                  _singleCardCategory('Birthday Cake',
                      'https://firebasestorage.googleapis.com/v0/b/e-commerce-2a07e.appspot.com/o/foodCategory%2Fbirthday-cake.png?alt=media&token=34936292-aa2e-4286-a7f6-1fe08a0e048f'),
                  _singleCardCategory('Chicken',
                      'https://firebasestorage.googleapis.com/v0/b/e-commerce-2a07e.appspot.com/o/foodCategory%2Fchicken.png?alt=media&token=0db2ab59-059c-4b6c-9168-e27c47892f32'),
                  _singleCardCategory('Fruit Juice',
                      'https://firebasestorage.googleapis.com/v0/b/e-commerce-2a07e.appspot.com/o/foodCategory%2Fcocktail.png?alt=media&token=b76f9cbd-2000-4c57-a2a1-d4668523476d'),
                  _singleCardCategory('Fish',
                      'https://firebasestorage.googleapis.com/v0/b/e-commerce-2a07e.appspot.com/o/foodCategory%2Ffish.png?alt=media&token=ca1e88fc-03e2-4b39-91df-92f3b032b326'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _singleCardCategory(
    String name,
    String imgLink,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AllFoods(
                      foodRef: name,
                    )));
        print(name);
      },
      child: Container(
          height: 200,
          width: 140,
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: 130,
                    width: 130,
                    padding: EdgeInsets.all(5),
                    child: Image(
                      image: NetworkImage(imgLink),
                      fit: BoxFit.cover,
                    )),
                Divider(
                  height: .3,
                  color: Colors.black54,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    name,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        letterSpacing: .7),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
