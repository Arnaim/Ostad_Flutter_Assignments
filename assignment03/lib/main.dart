import 'package:assignment03/productController.dart';
import 'package:flutter/material.dart';
import 'package:assignment03/widgets/productCard.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProductApp(),
  ));
}

class ProductApp extends StatefulWidget {
  const ProductApp({super.key});

  @override
  State<ProductApp> createState() => _CrudProducts();
}

class _CrudProducts extends State<ProductApp> {
  final Productcontroller productcontroller = Productcontroller();

  Future<void> fetchData() async {
    await productcontroller.FetchProducts();
    setState(() {});
    print(productcontroller.products.length);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void productDialog({String ? id, String ? name, String ? img, int ? qty, int ? unitPrice, int ? totalPrice, required bool isUpdate}){
    TextEditingController productNameController = TextEditingController();
    TextEditingController productQtyController = TextEditingController();
    TextEditingController productImageController = TextEditingController();
    TextEditingController productUnitPriceController = TextEditingController();
    TextEditingController productTotalPriceController = TextEditingController();

    productNameController.text = name ?? '';
    productQtyController.text = qty != null ? qty.toString() : '0';
    productImageController.text = img ?? '';
    productUnitPriceController.text = unitPrice != null ? unitPrice.toString() : '0';
    productTotalPriceController.text = totalPrice != null ? totalPrice.toString() : '0';


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isUpdate ? 'Edit Product' : 'Add Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: productNameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: productQtyController,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              TextField(
                controller: productImageController,
                decoration: const InputDecoration(labelText: 'Image'),
              ),
              TextField(
                controller: productUnitPriceController,
                decoration: const InputDecoration(labelText: 'Unit Price'),
              ),
              TextField(
                controller: productTotalPriceController,
                decoration: const InputDecoration(labelText: 'Total Price'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: () async {
                      productcontroller.CreateAndUpdateProduct(
                        productNameController.text,
                        productImageController.text,
                        int.parse(productQtyController.text),
                        int.parse(productUnitPriceController.text),
                        int.parse(productTotalPriceController.text),
                        id,
                        isUpdate,
                      ).then((value) async {
                        if (value) {
                          await productcontroller.FetchProducts();
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text( isUpdate ? 'Product Updated' : 'Product Deleted'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        } else {
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Something went wrong... Try again?'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                       }
                      );
                      Navigator.pop(context);
                      await fetchData();
                      setState(() {
                        
                      });
                    },
                    child: Text(isUpdate ? 'Update Product' : 'Add Product'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Curd Product'),
        backgroundColor: Colors.yellow,
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: ()=>productDialog(isUpdate: false),
        child: const Icon(Icons.add),
      ),
        
        body: Padding(
          padding: const EdgeInsets.all(10), 
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20, 
              mainAxisSpacing: 20,  
              childAspectRatio: 0.7,
            ),
            itemCount: productcontroller.products.length,
            itemBuilder: (context, index) {
              var product = productcontroller.products[index];
              return ProductCard(
                onEdit: () {
                  productDialog(
                    name: product.productName,
                    img: product.img,
                    qty: product.qty,
                    id: product.sId,
                    unitPrice: product.unitPrice,
                    totalPrice: product.totalPrice,
                    isUpdate: true,
                  );
                },
                onDelete: () {
                  productcontroller
                      .DeleteProducts(product.sId.toString())
                      .then((value) async {
                    if (value) {
                      await productcontroller.FetchProducts();
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product Deleted'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Something went wrong... Try again?'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  });
                },
                product: product,
              );
            },
          ),
        ),
      );
     }
    }
