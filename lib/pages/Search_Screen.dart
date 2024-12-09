import 'package:flutter/material.dart';
import 'Detail_Screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Categories data
  final Map<String, List<Map<String, dynamic>>> categories = {
    'Orgânico': [
      {
        'label': 'Restos de Alimentos',
        'icon': Icons.restaurant,
        'image': 'https://jornalistaslivres.org/wp-content/uploads/2021/06/restos.jpg.webp',
        'description':
            'Incluem sobras de refeições como pedaços de carne, arroz, feijão, massas e outros alimentos cozidos...',
      },
      {
        'label': 'Cascas de Frutas',
        'icon': Icons.apple,
        'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcz0i3vuCihAWmvMIw8oZ8zKLAmzvZsgsXyQ&s',
        'description': 'Cascas e partes não consumidas de frutas como laranjas, bananas, etc...',
      },
     {
      
      'label': 'Vegetais',
      'icon': Icons.eco,
      'image': 'https://uploads.metroimg.com/wp-content/uploads/2023/08/23092503/Vegetais_2.jpg',
      'description': 'Incluem cascas, talos e folhas não utilizadas de vegetais como batatas, cenouras, couves e outros alimentos frescos. Assim como as cascas de frutas, esses resíduos são ideais para a compostagem. Podem ser adicionados em composteiras para a criação de adubo natural.'
    },
    {
      
      'label': 'Outros Biodegradáveis',
      'icon': Icons.nature,
      'image': 'https://www.cleanipedia.com/images/00d1hxgfwfa6/5HYq3SUenmIffNlfPIBC0/d05e4077c6ec3c695744a16f211ced1e/Mi5qcGc/1200w/planeta-terra-com-s%C3%ADmbolo-de-reciclagem-feito-de-folhas-verdes..jpg',
      'description': 'Incluem outros materiais orgânicos que podem se decompor naturalmente, como guardanapos de papel usados, filtros de café, saquinhos de chá, entre outros. Podem ser colocados na compostagem ou em locais destinados ao lixo orgânico. O importante é evitar o descarte desses resíduos no lixo comum.'
    }],

    'Recicláveis': [
      {
        'label': 'Papel e Papelão',
        'icon': Icons.description,
        'image': 'https://www.cbsaparasdepapel.com.br/imagens/informacoes/reciclagem-papelao-01.jpg',
        'description': 'Incluem papel usado, papelão e embalagens limpas...',
      },
      {
        'label': 'Plástico',
        'icon': Icons.local_drink,
        'image': 'https://cdn.mos.cms.futurecdn.net/WTXCtPFr6P7EygfJZ8DsA3.jpg',
        'description': 'Inclui embalagens plásticas, sacolas, garrafas PET, potes de plástico, entre outros. Enxague para remover restos de alimentos e seque antes de descartá-los nos coletores de recicláveis. Evite misturá-los com materiais contaminados, como plástico sujo de gordura ou óleo, pois isso pode comprometer o processo de reciclagem.'
      },  
      {
        'label': 'Vidro',
        'icon': Icons.wine_bar,
        'image': 'https://cempre.org.br/wp-content/uploads/2020/11/titimg-rec-vidro.png',
        'description': 'Garrafas, potes de vidro e frascos. Importante que estejam sem resíduos orgânicos ou químicos. Lave e retire tampas e rótulos, sempre que possível. Coloque em recipientes destinados a vidro, preferencialmente separados por cor (transparente, verde e âmbar). Vidros quebrados devem ser embalados em jornal para evitar acidentes.'
      },
      {
        'label': 'Metal',
        'icon': Icons.hardware,
        'image': 'https://www.reciclasampa.com.br/imgs/conteudos/5430_03_lata.jpg',
        'description': 'Latas de alumínio, aço, latas de alimentos, tampas metálicas e outros produtos de metal. Lave e seque bem antes de descartar. Podem ser levados a centros de reciclagem de metais, ou descartados junto aos outros recicláveis em coletores de coleta seletiva.'
      }
    ],
    'Perigosos': [
       {
    
      'label': 'Pilhas',
      'icon': Icons.battery_charging_full,
      'image': 'https://static.manualdaquimica.com/conteudo/images/as-pilhas-sao-dispositivos-muito-utilizados-no-dia-dia-58ada547e2409.jpg',
      'description': 'Incluem pilhas alcalinas e comuns usadas em diversos aparelhos eletrônicos, como controles remotos, lanternas, brinquedos, etc. As pilhas contêm metais pesados como mercúrio, cádmio e chumbo, que são prejudiciais ao meio ambiente. Devem ser levadas a pontos de coleta específicos para resíduos eletrônicos ou pilhas. Muitos estabelecimentos, como supermercados e farmácias, têm recipientes próprios para esse descarte.'
    },
    {
    
      'label': 'Baterias',
      'icon': Icons.battery_std,
      'image': 'https://s.zst.com.br/cms-assets/2021/01/bateria1.jpg',
      'description': 'Incluem baterias recarregáveis de celulares, laptops, eletrônicos portáteis e baterias de carro (automotivas). As baterias também contêm substâncias tóxicas e metais pesados. Baterias de celulares e laptops podem ser entregues em lojas de eletrônicos ou assistência técnica autorizada. As baterias automotivas devem ser levadas a centros de coleta específicos ou oficinas, onde são descartadas de forma ambientalmente segura.'
    },
    {
    
      'label': 'Lâmpadas',
      'icon': Icons.lightbulb,
      'image': 'https://www.pensamentoverde.com.br/wp-content/uploads/2018/11/descarte_lampada_interna.jpg',
      'description': 'Incluem lâmpadas fluorescentes, de LED, de vapor de sódio e de mercúrio, que são usadas para iluminação residencial e comercial. As lâmpadas fluorescentes e de vapor contêm mercúrio, o que as torna perigosas. Nunca descarte no lixo comum. Muitos locais, como supermercados e lojas de materiais de construção, aceitam lâmpadas em seus programas de coleta para reciclagem. Verifique se elas estão bem embaladas para evitar que quebrem durante o transporte.'
    },
    {
    
      'label': 'Medicamentos',
      'icon': Icons.medication,
      'image': 'https://www.cnnbrasil.com.br/wp-content/uploads/sites/12/2022/03/medicamentos-3.jpg',
      'description': 'Incluem comprimidos, cápsulas, xaropes, pomadas, seringas e outros produtos farmacêuticos vencidos ou em desuso. Medicamentos vencidos ou que não serão mais utilizados devem ser levados a farmácias ou postos de saúde que aceitam esses resíduos para descarte seguro. Nunca descarte medicamentos no lixo comum ou no vaso sanitário, pois substâncias químicas podem contaminar o solo e a água.'
    }
    ],
    'Eletrônicos': [
       {
      
      'label': 'Celulares',
      'icon': Icons.phone_android,
      'image': 'https://classic.exame.com/wp-content/uploads/2023/01/GettyImages-523191959.jpg?quality=70&strip=info&w=737',
      'description': 'Incluem celulares e smartphones antigos ou quebrados, além de seus acessórios, como carregadores e fones de ouvido. Celulares possuem metais pesados e outros componentes que podem poluir o solo e a água. Muitas lojas de eletrônicos, fabricantes e operadoras de telefonia mantêm programas de coleta para reciclagem de celulares. Em alguns locais, há incentivos para a entrega de aparelhos antigos. Nunca descarte celulares no lixo comum.'
    },
    {
      
      'label': 'Computadores',
      'icon': Icons.computer,
      'image': 'https://www.recicletronic.com.br/imagens/portal/descarte-de-pc_11830_372553_1611776121484_cover.jpg',
      'description': 'Incluem desktops, notebooks, monitores, mouses, teclados, impressoras e outros periféricos de informática. Computadores contêm materiais como chumbo, mercúrio e outros metais que podem contaminar o meio ambiente. Eles devem ser entregues a empresas especializadas em reciclagem de eletrônicos ou em centros de descarte de resíduos eletrônicos. Algumas fabricantes e assistências técnicas oferecem programas de recolhimento ou reciclagem, e até recompensas em troca de produtos antigos.'
    },
    {
      
      'label': 'Eletrodomésticos',
      'icon': Icons.kitchen,
      'image': 'https://centrodevitoria.com.br/wp-content/uploads/sites/13/2021/07/recic.png',
      'description': 'Incluem itens como geladeiras, micro-ondas, máquinas de lavar, ventiladores, entre outros eletrodomésticos usados ou quebrados. Eletrodomésticos de grande porte contêm materiais recicláveis e gases nocivos ao meio ambiente, especialmente em itens como geladeiras e ar-condicionados. Podem ser entregues em centros de coleta de grandes eletrodomésticos ou lojas que fazem esse tipo de descarte. Algumas lojas aceitam os aparelhos antigos na compra de novos produtos, incentivando a troca e a reciclagem. Equipamentos menores, como torradeiras e liquidificadores, podem ser levados a pontos de descarte de eletrônicos.'
    }
    ]
  };

  // Retrieve all items as a flat list for filtering
  List<Map<String, dynamic>> get allItems =>
      categories.values.expand((items) => items).toList();

  // Filtered items based on search query
  List<Map<String, dynamic>> get filteredItems {
    if (_searchQuery.isEmpty) return allItems;

    return allItems.where((item) {
      final searchLower = _searchQuery.toLowerCase();
      return item['label'].toString().toLowerCase().contains(searchLower) ||
          item['description'].toString().toLowerCase().contains(searchLower);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Pesquisar'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: Column(
        
        children: [
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar no ReciclAqui!',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: _searchQuery.isEmpty
                ? _buildCategories(context)
                : _buildSearchResults(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categories.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: entry.value.map((item) {
                    return _buildCard(
                      item['label'],
                      item['icon'],
                      item['image'],
                      item['description'],
                      context,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    if (filteredItems.isEmpty) {
      return Center(
        child: Text(
          'Nenhum resultado encontrado para "$_searchQuery"',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return ListTile(
          leading: Icon(item['icon'] as IconData),
          title: Text(item['label']),
          subtitle: Text(item['description']),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(
                  itemName: item['label'],
                  itemDescription: item['description'],
                  imageUrl: item['image'],
                ),
              ),
            );
          },
        );
      },
    );
  }

   Widget _buildCard(String label, IconData icon, String imageUrl,
      String description, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              itemName: label,
              itemDescription: description,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Container(
        width: 140,
        height: 140,
        margin: const EdgeInsets.only(right: 16, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.green),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}