import 'package:assignment03/models/product_models.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Data product; 
  const ProductCard({
    super.key, required this.onEdit, required this.onDelete, required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 140,
            
            child: Image.network(
              product.img.toString(),
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                //Product Name
                Text(
                product.productName.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                ),
                //Product Price
                Text(
                  'Price: ${product.unitPrice} | Qty: ${product.qty}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                )
              ],
            )
          
          ),
        Padding(padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: onEdit, icon: const Icon(Icons.edit, color: Colors.orange,)),
              const SizedBox(width: 5,),
              IconButton(onPressed: onDelete, icon: const Icon(Icons.delete, color: Colors.red,)),
            ],
          )
        )
      ],
      )
    );
  }
}
