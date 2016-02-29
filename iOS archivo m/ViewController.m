//
//  ViewController.m
//  SmartData
//
//  Created by OX on 4/23/14.
//  Copyright (c) 2014 Gil_developers. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

NSArray *arrayDataBase;  // Guarda todas las bases de datos
NSArray *arrayTables;  // Guarda todas las tablas de cada base de datos. las tablas contienen todos sus campos, el nombre de cada uno y el nombre de la tabla.
NSString *oneDataDirPath;  // Contiene la ruta de la carpeta de la aplicacion

NSString *tempDBname;
NSString *tempTBname;

NSMutableArray *arrayField;  //Guarda el tag de todos los campos
NSString *DBName;    // Nombre de la base de datos
NSString *DBTableName;     // Nombre de la tabla
NSMutableArray *arrayFieldNames;  // Guarda todos los nombres de los campos
NSMutableArray *arrayDataField;  // Guarda el dato en cada campo

NSString *KeyVerified;  // Verifica si el tipo de entrada de datos es numerio o alfabetico
NSTimer *KeyTimerProcesing;  // Realiza la verificacion periodica del campo para asegurar el tipo de entrada. (VerifyKey)
NSTimer *KeyTimerProcesing2;  // Realiza la verificacion periodica del campo para asegurar el tipo de entrada. (PrimaryKey)
BOOL processPrimaryKey;  // Indica que se esta editando una columna que utiliza primary key. YES permite un recorrido continuo por la columna hasta que el booleano sea NO, este se hace falso cuando se termina la ediccion de dicha columna.

// METADATA
NSMutableArray *arrayTableMetadata;   // Guarda la cantidad de filas que tendra la tabla por cada columna Y el tipo de dato que manejara cada columna.
NSMutableArray *arrayKeyBoardFieldType;  // Guarda el tipo de dato de utilizara cada campo. indica cual teclado utilizara, Tambien guarda los primaries key
NSInteger numOfColField;   // Indica la cantidad de campos por columna que tendra la base de datos

// SHOW DATA FOUND
NSMutableArray *arrayOBfieldNames;  // Guarda los Uilabels de cada nombre de cada campo
NSMutableArray *arrayOBNumRows;  // Guarda los Uilabels de cada nombre de cada campo
NSMutableArray *arrayDataFound;  // Guarda los datos encontrados para que el metodo ShowDataFound verifique si existe el array y permita establecer el color de fabrica del los labels y el textfield. Al presionar sobre un textfield se invoca dicho metodo que recibira el tag del textfield, obtendra el dato de este y lo comparara con los datos del array. Los datos del array se obtienen cuando el usuario intenta buscar un dato en la tabla y es encontrado...Los datos se guardan tantas veces como son encontrados.
NSMutableArray *arrayColorFieldDataFound; // Contiene temporalmente el color de los campos que contienen el dato buscado.

// DELETE
NSMutableArray *arrayDBButton;  // Contiene los objetos botones de las base de datos. Permite elimanarlas
NSMutableArray *arrayTBButton;  // Contiene los objetos botones de las tablas. Permite eliminarlas.
BOOL canErasedbtb;   // Indica que esta borrando una base de datos o una tabla. Cuando es verdadero impide que se acceda a la Db o tb, ya que esta siendo utilizada.
UIButton *delete;
UIButton *edit;
UIButton *enterInConsole;
NSInteger tablePressedTag;
NSTimer *deleteTimer;

// SHEET
UIButton *mainSheetButton;
UIView *viewSheetPanelScroll;
UIScrollView *sheetPanelScroll;
NSMutableArray *arrayContentFromTableSheetRoot; // Posee el contenido (el noombre de las hojas: sheet 1 ... n) de las hojas de la tabla
NSMutableArray *arrayDataSheet; // Contiene los datos de las hojas
NSMutableArray *arrayBtnSheet; // Contiene los objetos botones de cada hoja
NSString * SheetPath;  // Contiene la ruta de la hoja actual
UIButton *eraseSheetButton; // Boton que permite borrar las hojas

// EDIT FIELD NAME
NSInteger indexArrayFieldName;

// PASSWORD
NSMutableArray *arrayTablePass;

// CONTRACT
UIWebView *configContractWebView;
NSTimer *checkTimer;
NSInteger contractNumber;

// TABLE CAPACITY
UIProgressView *capacityTable;

//QUERY
UITextField *quertyTextField;
NSDictionary *queryDictionary;
NSMutableArray *recentQuerys;
NSMutableArray *querysLoaded;
NSMutableArray *arraydataQueryResult;
NSMutableArray *arrayFieldNameQueryResult;

// CONSOLE
UITextView *lineNumber;
UIView *consoleFieldName;
BOOL canMoveConsoleView;
NSString *ModeGraphORConsol;
UIView *externConsultView;
UIView *titleExternConsultView;
UIView *useDatabaseView;
UITextField *useDatabaseTxt; // Nombre de la base de datos en la que trabajara
UITextField * dbNameTxt;  // Nombre de la base de datos de donde obtendra los historiales de consultas
UIScrollView *recentQueryScroll;
UIView *backGrundLQHV;
UIView *loadQueryHistoryView;
UIScrollView *queryHistoryLoadScroll;
NSTimer *ckeckDatabasesAndTablesTimer;
dispatch_queue_t queue ;
// LEFT BAR
UIView *BGdatabasebtn;
UIView *BGquerybtn;

NSString *dateString;
NSString *currentDataInField; // Obtiene el dato contenido en el textfield presionado para compararlo con el dato que tendra cuando se quite el foco. Si son diferentes guardara los datos de la tabla.
// ASSISTANT
NSTimer *checkerDBTimer;
NSTimer *queryTextRecognizerTimer; // Verifica el query al momento de su introduccion (solo para consultas externas). Permite dezplegar un boton de ayuda que facilita el proceso, (en caso de realizar un INSERT)
UIButton * assistant;
BOOL found;
BOOL assistantForInsertion;
BOOL assistantForSelection;
BOOL assistantCreated;
BOOL errorAssistantConsult;
UIView *insertAssistantView;
UIView *selectAssistantView;
UIScrollView *selectAssistantScroll;
UITextField * database;
UITextField * table;
UILabel * info;
UIView *viewForScroll;
UIScrollView * assistantInsertScroll;
NSMutableArray * arrayTextFieldInsertAssistant; // Posee los textField que permtiran la entrada a cada campo. (Assistant)
NSMutableArray * arrayTextFieldSelectAssistant; // Posee los textField que contienen el conjunto de querys (select) que conformaran la consulta avanzada. (Assistant)
NSMutableArray * arrayClearTextFieldButtons; // Posee los botones que permiten borrar el texto de los textField de consultas
UISwitch *autoClearSwitch;

UIView *xViewExcelLabels;
UIView *yViewExcelLabels;

NSInteger coorYcol;  // Contiene la coordenada X de los campos a partir de un tag
NSInteger coorXrow;  // Contiene la coordenada Y de los campos a partir de un tag

NSInteger fila;

ADBannerView *bannerView;

UIFont *HeitiTC_16;
UIFont *HeitiTC_14;
UIFont *HeitiTC_12;

UIFont *MenuBarTbHTC_14;
UIFont *OperationBarFontHTC_11;

@implementation ViewController

#define HELP_URL @"https://www.dropbox.com/s/vita3bvb1t6g5ry/Onedtx%20-%20Policy%20and%20terms%20of%20use.txt"
#define Policy_And_TermsOfUse @"https://www.dropbox.com/s/vita3bvb1t6g5ry/Onedtx%20-%20Policy%20and%20terms%20of%20use.txt"
#define remote_Setting @"http://www.dropbox.com/s/yl8r3ml2vykdme1/Onedtx-%20Remote%20setting.txt"

#define defaultTableMode  @"Graphics"
#define graphicsTableMode @"Graphics"
#define consoleTableMode @"Console"
#define externConsultTableMode @"Extern"
#define tableModeFileName @"TableMode"

#define barColor [UIColor colorWithRed:0.3 green:0.5 blue:0.8 alpha:1.0]
#define normalStateTableInternalBtnColor [UIColor grayColor]
#define normalStateTableInternalBackGroundBtnColor [UIColor clearColor]
#define tableInternalButtonColor [UIColor colorWithRed:0.3 green:0.5 blue:0.8 alpha:1.0] // botones agregar (nuevo campo/hoja)
#define tableInternalBackGroundBtnColor [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]
#define viewOperationsColor [UIColor colorWithRed:0.969 green:0.969 blue:0.969 alpha:1.0]
#define excelTableViewBGColor [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]
#define AssistantQueryIndicator [UIColor colorWithRed:0.0 green:0.8 blue:1.0 alpha:1.0]

#define queryFolderName @"odxQueries"
#define passFolderName @"odxtbPasswords"
#define queryResultsFolderName @"OdxQueryResults"

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
  //  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (systemVersion < 9.0) {
        
        HeitiTC_16 = [UIFont fontWithName:@"Heiti TC" size:16];
        HeitiTC_14 = [UIFont fontWithName:@"Heiti TC" size:14];
        HeitiTC_12 = [UIFont fontWithName:@"Heiti TC" size:12];
        
        MenuBarTbHTC_14 = [UIFont fontWithName:@"Heiti TC" size:14];
        OperationBarFontHTC_11 = [UIFont fontWithName:@"Heiti TC" size:11];
        
    }
    else
    {
        HeitiTC_16 = [UIFont fontWithName:@"Heiti TC" size:16];
        HeitiTC_14 = [UIFont fontWithName:@"Heiti TC" size:14];
        HeitiTC_12 = [UIFont fontWithName:@"Heiti TC" size:12];
    
        MenuBarTbHTC_14 = [UIFont fontWithName:@"Heiti TC" size:13];
        OperationBarFontHTC_11 = [UIFont fontWithName:@"Heiti TC" size:10];
    }
    
    
    ModeGraphORConsol = defaultTableMode;
    
    arrayField = [[NSMutableArray alloc] initWithCapacity:0];  // Contiene los textFields
    arrayFieldNames = [[NSMutableArray alloc] initWithCapacity:0];  // Contiene los nombres de cada columna
    arrayKeyBoardFieldType = [[NSMutableArray alloc] initWithCapacity:0];   // Contiene el tipo de dato que manejara cada columna. Define el tipo de teclado que invocara.
    arrayTableMetadata = [[NSMutableArray alloc] initWithCapacity:0];
    arrayDataField = [[NSMutableArray alloc] initWithCapacity:0];
    arrayDataSheet = [[NSMutableArray alloc] initWithCapacity:0];
    arrayBtnSheet = [[NSMutableArray alloc] initWithCapacity:0];
    arrayContentFromTableSheetRoot = [[NSMutableArray alloc] initWithCapacity:0];
    
    arrayOBfieldNames = [[NSMutableArray alloc] initWithCapacity:0];  // Guarda el objeto label del nombre de cada campo
    arrayOBNumRows = [[NSMutableArray alloc] initWithCapacity:0];  // Guarda el objeto label del numero de cada fila
    arrayDataFound = [[NSMutableArray alloc] initWithCapacity:0];  // Guarda los datos encontrados
    arrayColorFieldDataFound = [NSMutableArray arrayWithCapacity:0]; // Contiene temporalmente el color de los campos que contienen el dato buscado.
    
    arrayDBButton = [[NSMutableArray alloc] initWithCapacity:0];  // Contiene los objetos botones base de datos.
    arrayTBButton = [[NSMutableArray alloc] initWithCapacity:0];  // Contiene los objetos botones tablas
    
    arraydataQueryResult = [[NSMutableArray alloc] initWithCapacity:0];
    arrayFieldNameQueryResult = [[NSMutableArray alloc] initWithCapacity:0];
    arrayTextFieldInsertAssistant = [[NSMutableArray alloc] initWithCapacity:0];
    arrayTextFieldSelectAssistant = [[NSMutableArray alloc] initWithCapacity:0];
    arrayClearTextFieldButtons = [[NSMutableArray alloc] initWithCapacity:0];
    
    DbTbviewController = [DbTbclass new];
    TxtLoader = [TxtLoaderViewController new];
    Legal = [LegalViewController new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resingNotificationsForCreateDBorTB:) name:@"NewProjectNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resingNotificationsForCreateDBorTB:) name:@"PrimaryKeyNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resingNotificationsForCreateDBorTB:) name:@"TableDataFromTxt" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resingNotificationsForCreateDBorTB:) name:@"TableDataFromCSVFile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resingNotificationsForCreateDBorTB:) name:@"UpdateTable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resingNotificationsForCreateDBorTB:) name:@"legalContract" object:nil];
    
    
    [self loadTableConfiguration];
    [self createInterface];
    [self processingContract];
    
   checkerDBTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkIfExistDatabases) userInfo:nil repeats:YES];
    
 //   NSLog(@"%@ %i",[self permute:@"1234"],[[self permute:@"1234"] count]);
}
/*
 -(NSMutableArray *)permute:(NSString *)permutation
 {
 NSString * pchar;
 NSString * schar;
 NSString * rchar;
 NSString * lchar;
 NSString * right = @"";
 NSString * left = @"";
 NSMutableArray * result = [[NSMutableArray alloc] initWithCapacity:0];
 
 for (int p = 0; p < [permutation length]; p++) {
 
     pchar = [NSString stringWithFormat:@"%c",[permutation characterAtIndex:p]];
 
     for (int s = 0; s < [permutation length]; s++) {
 
         right = @""; left = @"";
         schar = [NSString stringWithFormat:@"%c",[permutation characterAtIndex:s]];
         if ([schar isEqualToString:pchar]) { continue; }
 
         right = [right stringByAppendingString:[NSString stringWithFormat:@"%@%@",pchar,schar]];
         left = [left stringByAppendingString:[NSString stringWithFormat:@"%@%@",pchar,schar]];
 
         for (int i = 0; i < [permutation length]; i ++) {
     
             rchar = [NSString stringWithFormat:@"%c",[permutation characterAtIndex:i]];
             lchar = [NSString stringWithFormat:@"%c",[permutation characterAtIndex:([permutation length] - i) - 1]];
 
             if (![rchar isEqualToString:pchar] && ![rchar isEqualToString:schar]) { right = [right stringByAppendingString:rchar]; }
 
             if (![lchar isEqualToString:pchar] && ![lchar isEqualToString:schar]) { left = [left stringByAppendingString:lchar]; }
         }
         [result addObject:right];
         [result addObject:left];
     }
 }
 
 return result;
 }
*/

#pragma CARGA LAS CONFIGURACIONES DE LA TABLA
-(void)loadTableConfiguration
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:tableModeFileName] length] > 0) { ModeGraphORConsol = [[NSUserDefaults standardUserDefaults] objectForKey:tableModeFileName]; } else { ModeGraphORConsol = graphicsTableMode; } // Si no encuentra una configuracion establecida, carga la tabla en modo grafico por defecto.
}

#pragma VERIFICA LA EXISTENCIA DE LAS BASES DE DATOS
-(void)checkIfExistDatabases
{
    if ([arrayDBButton count] == 0) { if (scrollDataBase.alpha == 1.0 && scrollDataBase.superview) { [self NewDataBase]; }}
    else if ([arrayDBButton count] == 1) { if (!scrollDataBase.subviews) { [self NewDataBase]; }}
}

-(void)resingNotificationsForCreateDBorTB:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"PrimaryKeyNotification"]) {  // Recibe los datos del campo seleccionados y los guarda en su respectivo array
        
        [arrayFieldNames addObject:[[notification userInfo] objectForKey:@"TBfieldName"]];
        [arrayKeyBoardFieldType addObject:[[notification userInfo] objectForKey:@"PK"]];
    }
    
    else if ([[notification name] isEqualToString:@"NewProjectNotification"])   // Se envia esta notificacion cuando se esta creando un base de datos o una tabla
    {
        
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
    [arrayDataField removeAllObjects]; // Liberando el array de los datos guardados anteriormente
    [arrayField removeAllObjects];  // Liberando el array de los Campos creados anteriormente
    
    DBName = [[notification userInfo] objectForKey:@"DBname"];
    DBTableName = [[notification userInfo] objectForKey:@"TBname"];
    numOfColField = [[[notification userInfo] objectForKey:@"NumRows"] integerValue];
    
    tempTBname = DBTableName;
    tempDBname = DBName;
    
    [self createExcelTableWithName:DBTableName ColFieldNames:arrayFieldNames PlaceIn:CGRectMake(0, 180, 1024, 588) InView:self.view Alpha:1.0 ThenCreateNumFieldsInX:[arrayFieldNames count] FieldsInY:numOfColField WithWidth:150 AndHeight:30 SpaceSize:0 AndKeyBoardType:arrayKeyBoardFieldType willCREATEorUPDATE:@"CREATE" modeINPUTorOUTPUT:graphicsTableMode];
        
        [self autoSetDataFromArray:arrayDataField InFieldForArrayFields:arrayField];
   
        [self autoSavingDataBase]; // Guardando proyecto
        
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.3];
    [viewTableContainer setFrame:CGRectMake(0, 0, 1024, 768)];
    [UIView commitAnimations];
        
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(removeScrollDataBase) userInfo:nil repeats:NO];// borra (DB)
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(removeScrollTables) userInfo:nil repeats:NO];  // borra (TB y DB)
    }
    else if ([[notification name] isEqualToString:@"TableDataFromTxt"])  // Recibe el txt de los archivos odx
    {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        array = [self setArrayTableWithContentFromTxt:[[notification userInfo] objectForKey:@"txtTBData"]];  // Guarda el contenido de la tabla (txt) temporalmente hasta verificar si el tamano del array es igual a la cantidad de textField creados en la tabla.
        
        if ([arrayField count] != [array count]) {
            
            [self createAlertWithTitle:@"No match" Message:@"The table or data is incorrect, you did not make the table with detailed specifications in the message" CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
        else
        {
            [arrayDataField removeAllObjects];
            arrayDataField = array;
            [array removeAllObjects];
      
            [self autoSetDataFromArray:arrayDataField InFieldForArrayFields:arrayField]; // Inserta los datos del arrayDataField en cada textField
        }
    }
    else if ([[notification name] isEqualToString:@"TableDataFromCSVFile"])  // Recibe el txt de los archivos csv
    {
            
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        [self importTableContentFromSQLData:[[notification userInfo] objectForKey:@"txtTBData"] InjectDataInArray:tempArray];  // Toma el archivo CSV y lo inyecta temporalmente en el tempaAray. Tambien utiliza el (tempArray) *arrayDataFiel* para borrar su contenido antes de almacenar los datos del archivo. Guarda temporalmente los datos del array para evitar perdida de datos. Si en la comparacion del tamano del array no es igual al tamano del arrayField, ArrayDataField quedara con su mismo valor, de lo contrario el arrayDataField tomara el valor del tempArray.

        if ([tempArray count] == [arrayField count]) {
            
            [arrayDataField removeAllObjects];
            arrayDataField = tempArray;
            
        if ([arrayField count] == [arrayDataField count]) {
            
            [self autoSetDataFromArray:arrayDataField InFieldForArrayFields:arrayField]; // Inserta los datos del arrayDataField en cada textField
        }}
        else
        {
            [self createAlertWithTitle:@"No match" Message:@"The table or data is incorrect, you did not make the table with the datailed specifications in the message." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
    }
    else if ([[notification name] isEqualToString:@"UpdateTable"])  // Actualiza la tabla y sus datos cuando se crea un nuevo campo
    {
        SheetPath = @"";
        [self updateTableWithNewFields];
        [self autoSavingDataBase];
    }
    else if ([[notification name] isEqualToString:@"legalContract"])  // Recibe la notificacion del viewController (legal). Cuando el usuario presiona agree envia por notificacion el acuerdo aceptado
    {
        [checkerDBTimer invalidate];
        checkerDBTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkIfExistDatabases) userInfo:nil repeats:YES];
        
        [self contractAgreementMethod:@"POST" IfitsPOSTsetChoiseOfContract:@"YES"];  // Cuando el contrato se modifica tambien se modifica la configuracion remota del contrato, una vez que encuentre un nuevo contrato se deshacera del anterior (borrara el acuerdo) y requerira la aceptacion del nuevo contrato.
    }
}

-(void)createInterface
{
    MainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 718)];
    [MainView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:MainView];
    
    /*bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, MainDBView.frame.size.height - 50,1000, 50)];
    bannerView.delegate = self;
    self.canDisplayBannerAds = YES;
    [MainView addSubview:bannerView];*/

    
    leftBarView = [[UIView alloc] init];
    [leftBarView setBackgroundColor:barColor];
    [leftBarView setFrame:CGRectMake(0, 0, 80, self.view.frame.size.height)];
    [MainView addSubview:leftBarView];
    
 /*   UIImageView * logo = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
    [logo setImage:[UIImage imageNamed:@"logo.png"]];
    logo.layer.borderWidth = 0.3f;
    logo.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [leftBarView addSubview:logo];*/
    
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, leftBarView.frame.size.width, 10)];
    [newLabel setText:@"NEW"];
    [newLabel setTextAlignment:NSTextAlignmentCenter];
    [newLabel setTextColor:[UIColor whiteColor]];
    [newLabel setFont:[UIFont fontWithName:@"Heiti TC" size:10]];
    [leftBarView addSubview:newLabel];
    
    UIButton *newDB = [[UIButton alloc] initWithFrame:CGRectMake(15, 150, 50, 50)];
    [newDB setImage:[UIImage imageNamed:@"newProj2.png"] forState:UIControlStateNormal];
    [newDB addTarget:self action:@selector(NewDataBase) forControlEvents:UIControlEventTouchDown];
    [leftBarView addSubview:newDB];
    
    BGdatabasebtn = [[UIView alloc] initWithFrame:CGRectMake(0, 230, leftBarView.frame.size.width, 90)];
    [BGdatabasebtn setBackgroundColor:[UIColor whiteColor]];
    [BGdatabasebtn setAlpha:0.3];
    [leftBarView addSubview:BGdatabasebtn];
    
    UILabel *dbLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, leftBarView.frame.size.width, 10)];
    [dbLabel setText:@"DATA BASE"];
    [dbLabel setTextAlignment:NSTextAlignmentCenter];
    [dbLabel setTextColor:[UIColor whiteColor]];
    [dbLabel setFont:[UIFont fontWithName:@"Heiti TC" size:10]];
    [leftBarView addSubview:dbLabel];
    
    UIButton *dataBases = [[UIButton alloc] initWithFrame:CGRectMake(15, 250, 50, 50)];
    [dataBases setImage:[UIImage imageNamed:@"database_ext2.png"] forState:UIControlStateNormal];
    [dataBases addTarget:self action:@selector(DataBases) forControlEvents:UIControlEventTouchDown];
    [leftBarView addSubview:dataBases];
    
    BGquerybtn = [[UIView alloc] initWithFrame:CGRectMake(0, 330, leftBarView.frame.size.width, 90)];
    [BGquerybtn setBackgroundColor:[UIColor whiteColor]];
    [BGquerybtn setAlpha:0.0];
    [leftBarView addSubview:BGquerybtn];
    
    UILabel *qrLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, leftBarView.frame.size.width, 10)];
    [qrLabel setText:@"QUERY"];
    [qrLabel setTextAlignment:NSTextAlignmentCenter];
    [qrLabel setTextColor:[UIColor whiteColor]];
    [qrLabel setFont:[UIFont fontWithName:@"Heiti TC" size:10]];
    [leftBarView addSubview:qrLabel];
    
    UIButton *newConsult = [[UIButton alloc] initWithFrame:CGRectMake(15, 350, 50, 50)];
    [newConsult setImage:[UIImage imageNamed:@"consultExtern.png"] forState:UIControlStateNormal];
    [newConsult addTarget:self action:@selector(NewConsulte) forControlEvents:UIControlEventTouchDown];
    [leftBarView addSubview:newConsult];
    
    UIButton *legal = [[UIButton alloc] initWithFrame:CGRectMake(15, 680, 50, 50)];
    [legal setImage:[UIImage imageNamed:@"legal3.png"] forState:UIControlStateNormal];
    [legal addTarget:self action:@selector(policyAndTermsOfUse) forControlEvents:UIControlEventTouchDown];
    [leftBarView addSubview:legal];
    
    MainDBView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, self.view.frame.size.width - 80, self.view.frame.size.height)];
    [MainDBView setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.03]];
    [MainView addSubview:MainDBView];
    
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 23)];
    [bar setBackgroundColor:[UIColor whiteColor]];
    bar.layer.borderWidth = 0.3;
    bar.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [MainView addSubview:bar];
    
    titleScrollDBView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainDBView.frame.size.width, 80)];
    [titleScrollDBView setBackgroundColor:[UIColor whiteColor]];
    [MainDBView addSubview:titleScrollDBView];
    
    titleBar = [[UILabel alloc] initWithFrame:CGRectMake(titleScrollDBView.center.x - (70 + 40), 30, 140, 50)];
    [titleBar setText:@"Data bases"];
    titleBar.numberOfLines = 2;
    [titleBar setFont:[UIFont fontWithName:@"Heiti TC" size:17]];
    [titleBar setTextAlignment:NSTextAlignmentCenter];
    [titleBar setTextColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.6]];
    [titleScrollDBView addSubview:titleBar];
    
    backToDataBase = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, 35, 35)];
    [backToDataBase setImage:[UIImage imageNamed:@"backTodb.png"] forState:UIControlStateNormal];
    [backToDataBase setAlpha:0.0];
    [backToDataBase setTag:0];
    [backToDataBase setTitleColor:[UIColor colorWithRed:0 green:0.5 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [backToDataBase addTarget:self action:@selector(resingBarTablesAction:) forControlEvents:UIControlEventTouchDown];
    [titleScrollDBView addSubview:backToDataBase];

    newTB = [[UIButton alloc] initWithFrame:CGRectMake(100, 40, 35, 35)];
    [newTB setImage:[UIImage imageNamed:@"new pro 2j.png"] forState:UIControlStateNormal];
    [newTB setAlpha:0.0];
    [newTB setTitleColor:[UIColor colorWithRed:0 green:0.5 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [newTB addTarget:self action:@selector(NewTable) forControlEvents:UIControlEventTouchDown];
    [titleScrollDBView addSubview:newTB];
    
    [self superInit];
}

-(void)superInit
{
    [self verifyAppDirectory];
}
# pragma CREA LA CARPETA DE LA APP SI NO EXISTE
-(void)verifyAppDirectory   // Verifica si existe la carpeta OneData. Carga el array con el nombre de cada base de datos e invoca el metodo que crea el View vinculos de las DB
{
    NSArray *dirDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [dirDocuments objectAtIndex:0];
    NSString *oneDataPath = [path stringByAppendingString:@"/OneData"];
    oneDataDirPath = oneDataPath;   // contiene la ruta de la app
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:oneDataPath]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:oneDataPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
        arrayDataBase = [self getDataBaseNamesFromRootpath:oneDataDirPath];  // Cargando el array con el nombre de las base de datos en el dispositivo
        
        [self createDBviewsWithNameFromArray:arrayDataBase WithWidth:200 AndHeight:180 SpaceSize:30 InPlace:CGRectMake(25, 90, MainDBView.frame.size.width - 25, MainDBView.frame.size.height - 90) InView:MainDBView Alpha:1.0];
}

# pragma CREA EL SCROLL CON LAS TABLAS DE UNA BASE DE DATOS
-(void) createTBviewsWithNameFromArray:(NSArray *)array WithWidth:(NSInteger)Width AndHeight:(NSInteger )Height SpaceSize:(NSInteger)spaceSize InPlace:(CGRect)rect InView:(UIView *)view Alpha:(NSInteger)alpha
{
    if (!scrollTables.superview) {

        scrollTables = [[UIScrollView alloc] initWithFrame:rect];
        [scrollTables setBackgroundColor:[UIColor clearColor]];
        [scrollTables setScrollEnabled:YES];
        scrollTables.delegate = self;
        scrollTables.alpha = alpha;
        [view addSubview:scrollTables];
    }
    
    [self createBtnviewsWithNameFromArray:array WithWidth:Width AndHeight:Height SpaceSize:spaceSize InPlace:rect InView:scrollTables FuntionDB_or_TB:@"TB"];
}

# pragma CREA EL SCROLL CON LAS BASES DE DATOS EXISTENTES
-(void) createDBviewsWithNameFromArray:(NSArray *)array WithWidth:(NSInteger)Width AndHeight:(NSInteger )Height SpaceSize:(NSInteger)spaceSize InPlace:(CGRect)rect InView:(UIView *)view  Alpha:(NSInteger)alpha
{
    if (!scrollDataBase.superview) {
    
        scrollDataBase = [[UIScrollView alloc] initWithFrame:rect];
        [scrollDataBase setBackgroundColor:[UIColor clearColor]];
        [scrollDataBase setScrollEnabled:YES];
        scrollDataBase.delegate = self;
        scrollDataBase.alpha = alpha;
        [view addSubview:scrollDataBase];
    }
    
    [self createBtnviewsWithNameFromArray:array WithWidth:Width AndHeight:Height SpaceSize:spaceSize InPlace:rect InView:scrollDataBase FuntionDB_or_TB:@"DB"];
}

# pragma PROCESO
-(void) createBtnviewsWithNameFromArray:(NSArray *)array WithWidth:(NSInteger)Width AndHeight:(NSInteger )Height SpaceSize:(NSInteger)spaceSize InPlace:(CGRect)rect InView:(UIView *)view FuntionDB_or_TB:(NSString *)funtion // Funtion: indica si los botones que creara seran para las bases de datos (permitiran ir a las tablas) o para las tablas (permitiran acceder a los datos de la tabla). Los botones se almacenan en sus respectivos arrays que permiten la eliminacion de bases datos o tablas.
{
    NSInteger X = 0;
    NSInteger Y = 0;
    NSInteger btnTag = 0;
    NSInteger xcount = 0;
    NSInteger ycount = 0;
    NSInteger iycount = 0;
    
    if ([funtion isEqualToString:@"DB"]) {
        
        [arrayDBButton removeAllObjects];  // Borra los objetos guardados anteriormente (db).
    }
    else if ([funtion isEqualToString:@"TB"])
    {
        [arrayTBButton removeAllObjects];  // Borra los objetos guardados anteriormente (tb).
    }
        
    for (int i = 0; i < [array count]; i++) {
        
        if ([funtion isEqualToString:@"DB"]) {
            
            [arrayDBButton addObject:@""];  // Deja un espacio para almacenar el boton en el indice indicado
        }
        else if ([funtion isEqualToString:@"TB"])
        {
            [arrayTBButton addObject:@""];  // Deja un espacio para almacenar el boton en el indice indicado
        }
        if (![[[array objectAtIndex:i] pathExtension] isEqualToString:@"Metadata"] && ![[[array objectAtIndex:i] pathExtension] isEqualToString:@"Sheet"] && ![[array objectAtIndex:i] isEqualToString:@"odxtbPasswords"] && ![[array objectAtIndex:i] isEqualToString:@"odxQueries"] && ![[array objectAtIndex:i] isEqualToString:@"OdxQueryResults"]) {
            
        X = (Width + spaceSize) * xcount;
        Y = ((Height + 20) + spaceSize) * ycount;
        
            if ([funtion isEqualToString:@"DB"]) {
                
                [scrollDataBase setContentSize:CGSizeMake(0, ((Height + 20) + spaceSize) * (ycount + 1))];
            }
            else if ([funtion isEqualToString:@"TB"])
            {
                [scrollTables setContentSize:CGSizeMake(0, ((Height + 20) + spaceSize) * (ycount + 1))];
            }
   
        xcount ++;
        iycount ++;
        
        if (iycount == 4) {
            iycount = 0;
            ycount ++;
            xcount = 0;
        }
            
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(X, Y, Width, Height)];
        [btnView setBackgroundColor:[UIColor clearColor]];
        [view addSubview:btnView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, btnView.frame.size.height - 20, Width, 30)];
        [label setText:[array objectAtIndex:btnTag]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont fontWithName:@"Heiti TC" size:15]];
        [label setTextColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.6]];
        [btnView addSubview:label];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 160)];
        [button setBackgroundColor:[UIColor whiteColor]];
       /*     if ([funtion isEqualToString:@"TB"]) {
            [button setBackgroundImage:[UIImage imageNamed:@"tablebtnimage3.png"] forState:UIControlStateNormal];
             }*/
        [button setTag:btnTag];
        [button addTarget:self action:@selector(resingDBbuttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(resingButtonForDeleteDBorTB:) forControlEvents:UIControlEventTouchDown];
        button.layer.borderWidth = 0.3;
        button.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
        [btnView addSubview:button];
            
            if ([funtion isEqualToString:@"DB"]) {
                
                [arrayDBButton replaceObjectAtIndex:btnTag withObject:btnView]; // Reemplaza el objeto boton con el espacio reservado. No quedan espacios nulos.
            }
            else if ([funtion isEqualToString:@"TB"])
            {
                [arrayTBButton replaceObjectAtIndex:btnTag withObject:btnView]; // Reemplaza el objeto boton con el espacio reservado. Solo guarda los botones cuyo arrayTable contiene el nombre de la tabla sin la extension .Metadata. quedan espacios nulos
            }
        }
        btnTag ++;
    }
}

# pragma RECIBE LA PULSACIONES EN LAS DB Y TB
-(void)resingDBbuttonPressed:(id)sender
{
    [deleteTimer invalidate];  // Deshabilita el timer para que no permita entrar en modo borrado.
    
    if (canErasedbtb  == NO) {  // Indica que no se esta tratando de borrar la tabla o la base de datos.
        
    if (scrollDataBase.alpha == 1.0) {
        
        arrayTables = [self getTableNamesFromDataBaseName:[arrayDataBase objectAtIndex:[sender tag]] RootPath:oneDataDirPath];   // Cargando el array con las tablas de la DB
        
        tempDBname = [arrayDataBase objectAtIndex:[sender tag]];   // Toma el nombre de la base de datos seleccionada para usarla en para cargar la tabla
   
    [self createTBviewsWithNameFromArray:[self getTableNamesFromDataBaseName:[arrayDataBase objectAtIndex:[sender tag]] RootPath:oneDataDirPath] WithWidth:200 AndHeight:180 SpaceSize:30 InPlace:CGRectMake(25, 90, MainDBView.frame.size.width - 25, MainDBView.frame.size.height - 90) InView:MainDBView Alpha:0.0];
        
        [titleBar setText:tempDBname];
        
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.3];
    [scrollTables setAlpha:1.0];
    [scrollDataBase setAlpha:0.0];
    [newTB setAlpha:1.0];   // nueva tabla
    [backToDataBase setAlpha:1.0];   // volver
    [UIView commitAnimations];
    
    }
    else if (scrollTables.alpha == 1.0)
    {
        [self loadTableConfiguration];
        [self invocateTableWithMode:ModeGraphORConsol Tag:[sender tag]]; // Invoca la tabla presionada
    }}
}
-(void)invocateTableWithMode:(NSString *)mode Tag:(NSInteger )tag
{
    tempTBname = [arrayTables objectAtIndex:tag];  // Toma el nombre de la tabla para usarla para cargar la tabla
    
    if ([[self lookForTableKeyAtDBPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,tempDBname] WithTableName:tempTBname Funtion:@"GET" ForCasePOSTSetTheReferenceQuestion:nil Password:nil] count] == 0) {  // Busca en la carpeta de contrasenas de la base de datos, Si no se encontro ningun archivo (nombretabla.pass) el tamano del array sera 0 indicando que la tabla no posee contrasena.
        
        [self allocTableWithDataBaseName:tempDBname AtPath:[NSString stringWithFormat:@"%@/%@/%@",oneDataDirPath,tempDBname,tempTBname] FUNTION:@"CREATE" MODE:mode];  // Cargando tabla de la DB y TB seleccionadas. (FUNTION: indica si creara o actualizara la tabla)
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(removeScrollTables) userInfo:nil repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(removeScrollDataBase) userInfo:nil repeats:NO];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.3];
        [newTB setAlpha:0.0];   // nueva tabla
        [backToDataBase setAlpha:0.0];   // volver
        [viewTableContainer setFrame:CGRectMake(0, 0, 1024, 768)];
        [UIView commitAnimations];
        
        [UIView beginAnimations:NULL context:NULL]; // View principal
        [UIView setAnimationDuration:0.6];
        [MainView setFrame:CGRectMake(-200, 0, 1024, 768)];
        [UIView commitAnimations];
    }
    else  // El tamano del array es mayor que 0. (indica que la tabla posee contrasena)
    {
        [self passwordAlert];
    }
}

-(void)passwordAlert
{
    NSString *RQ = [[self lookForTableKeyAtDBPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,tempDBname] WithTableName:tempTBname Funtion:@"GET" ForCasePOSTSetTheReferenceQuestion:nil Password:nil] objectAtIndex:0];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password" message:[NSString stringWithFormat:@"The table has a password, enter it below to unlock data.\n\nReference word: %@ ",RQ] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Unlock", nil];
    [alert setTag:8];
    [alert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    [alert show];
}

-(void)removeScrollDataBase
{
    [scrollDataBase removeFromSuperview];
}
-(void)removeScrollTables
{
    [scrollTables removeFromSuperview];
}
-(void)removeTable
{
    [viewTableContainer removeFromSuperview];
}
-(void)removeTableConsole
{
    [tableConsoleView removeFromSuperview];
}
-(void)removeExternConsulteView
{
    [externConsultView removeFromSuperview];
    [titleExternConsultView removeFromSuperview];
}
-(void)removeDeleteButton
{
    [delete removeFromSuperview];
    [edit removeFromSuperview];
    [enterInConsole removeFromSuperview];
    canErasedbtb = NO;
}
-(void)removeLoadQueryView
{
    [backGrundLQHV removeFromSuperview];
    [loadQueryHistoryView removeFromSuperview];
}

# pragma BORRA LA DASE DE DATOS O TABLA INDICADA
-(void)resingButtonForDeleteDBorTB:(id)sender
{
    NSString *identifier;  // Identifica si borrara una base de datos o una tabla.
    
    if (scrollDataBase.alpha == 1.0) {  // Esta en vista de base de datos. Borrara una base de datos
        
        tempDBname = [arrayDataBase objectAtIndex:[sender tag]];   // Toma el nombre de la base de datos seleccionada para usarla en para eliminar la tabla
        identifier = @"DataBase";
    }
    else if (scrollTables.alpha == 1.0)  // Esta en vista de tablas. Borrara una tabla
    {
        tempTBname = [arrayTables objectAtIndex:[sender tag]];  // Toma el nombre de la tabla para usarla para eliminar la tabla
        identifier = @"Table";
    }
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.3];
    [delete setFrame:CGRectMake(12, 12, 0, 0)];
    [edit setFrame:CGRectMake(2, 35, 0, 0)];
    [enterInConsole setFrame:CGRectMake(2, 35, 0, 0)];
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(removeDeleteButton) userInfo:nil repeats:NO]; // Si el boton borrar esta visible el booleano canErasedbtb es verdadero, cuando el usuario presiona sobre una db o tb (porque no desea eliminarla y desea salir del modo borrado)... Cuando elimina el boton borrar, tambien establece el bool (CanErasedbtb = no) para que cuando el usuario al volver a presionar a la db o tb pueda entrar a ella
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%i",(int)[sender tag]],@"tag",identifier,@"identifier", nil];
   deleteTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(prepareForDeleteWithTag:) userInfo:dic repeats:NO];//  Si se matiene presionado el tiempo establecido (0.5f seg) entrara en modo de borrado, si se suelta el boton antes de el tiempo indicado, entrara a la base de datos o la tabla seleccionada (boton: UIcontrolEventTouchUpside) y deshabilitara el timer (deleteTimer). Cuando se mueve el scroll se desactiva el timer, indicando que no se trata de borrar la tabla o base de datos.
}

-(void)prepareForDeleteWithTag:(NSTimer *)userInfoByTimer
{
    canErasedbtb = YES;
    
    if (canErasedbtb == YES) {   // Se mantuvo el boton (db o tb) presionado el tiempo establecido. Si el boton es soltado antes de los 0.5 segundos el metodo resingDBbuttonPressed (invocado por el mismo boton en el evento UIcontrolEventTouchUpSide) hara el booleano falso y desactivara el timer (deleteTimer).
  
        NSInteger senderTag = [[[userInfoByTimer userInfo] objectForKey:@"tag"] integerValue];
        tablePressedTag = senderTag;  // Permite indicar el modo de entrada de la tabla (Console) ya que se conoce la tabla seleccionada.
        
        if ([[[userInfoByTimer userInfo] objectForKey:@"identifier"] isEqualToString:@"DataBase"]) {
  
    for (int i = 0; i < [arrayDBButton  count]; i ++) {
        
        if (i == senderTag) {
            
            [self createDeleteButtonIdentifier:@"DataBase" ButtonTag:i ArrayButton:arrayDBButton];
            break;
        }
    }}
        else if ([[[userInfoByTimer userInfo] objectForKey:@"identifier"] isEqualToString:@"Table"])
        {
            for (int i = 0; i < [arrayTBButton  count]; i ++) {
                
                if (i == senderTag) {
                    
                    [self createDeleteButtonIdentifier:@"Table" ButtonTag:i ArrayButton:arrayTBButton];
                    break;
                }
            }}}
}
-(void)createDeleteButtonIdentifier:(NSString *)identifier ButtonTag:(NSInteger)tag ArrayButton:(NSMutableArray *)arrayButton
{
    delete = [[UIButton alloc] initWithFrame:CGRectMake(12, 12, 0, 0)];
    [delete setTitle:@"X" forState:UIControlStateNormal];
    [delete setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [[delete titleLabel] setFont:HeitiTC_16];
    [[delete titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [delete setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.1]];
    delete.layer.cornerRadius = 12;
    delete.layer.borderWidth = 0.3;
    delete.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [delete addTarget:self action:@selector(createDeleteMessageAlert) forControlEvents:UIControlEventTouchDown];
    
    edit = [[UIButton alloc] initWithFrame:CGRectMake(12, 35, 0, 0)];
    [edit setTitle:@"i" forState:UIControlStateNormal];
    [edit setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [[edit titleLabel] setFont:HeitiTC_16];
    [[edit titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [edit setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.1]];
    edit.layer.cornerRadius = 12;
    edit.layer.borderWidth = 0.3;
    edit.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [edit addTarget:self action:@selector(editDataBase) forControlEvents:UIControlEventTouchDown];
    
    enterInConsole = [[UIButton alloc] initWithFrame:CGRectMake(12, 35, 0, 0)];
    [enterInConsole setTitle:@"....." forState:UIControlStateNormal];
    [enterInConsole setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [[enterInConsole titleLabel] setFont:[UIFont fontWithName:@"Heiti TC" size:23]];
    [[enterInConsole titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [enterInConsole setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.1]];
    enterInConsole.layer.cornerRadius = 12;
    enterInConsole.layer.borderWidth = 0.3;
    enterInConsole.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [enterInConsole addTarget:self action:@selector(enterInModeConsole) forControlEvents:UIControlEventTouchDown];
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.3];
    [delete setFrame:CGRectMake(2, 2, 25, 25)];
    [edit setFrame:CGRectMake(2, 35, 25, 25)];
    [enterInConsole setFrame:CGRectMake(2, 35, 25, 25)];
    [UIView commitAnimations];
    
    if ([identifier isEqualToString:@"DataBase"]) {  // Creara el boton borrar y editar sobre una base de datos
        
        [(UIView *)[arrayButton objectAtIndex:tag] addSubview:delete];
        [(UIView *)[arrayButton objectAtIndex:tag] addSubview:edit];
    }
    else if ([identifier isEqualToString:@"Table"]) {  // Creara el boton borrar sobre una tabla
        
        [(UIView *)[arrayButton objectAtIndex:tag] addSubview:delete];
        [(UIView *)[arrayButton objectAtIndex:tag] addSubview:enterInConsole];
    }
}
-(void)createDeleteMessageAlert
{
    NSString *title;
    NSString *message;
    
    if (scrollDataBase.alpha == 1.0) {  // Borrara una base de datos
        
        title = @"Delete data base";
        message = [NSString stringWithFormat:@"Are you sure you want delete the data base \"%@\"?",tempDBname];
    }
    else if (scrollTables.alpha == 1.0)  // Borrara una tabla
    {
        title = @"Delete table";
        message = [NSString stringWithFormat:@"Are you sure you want delete the table \"%@\"?",tempTBname];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert setTag:3];
    [alert show];
}
-(void)editDataBase
{
    NSString *message = [NSString stringWithFormat:@"You are editting the data base \"%@\". Select the kind of action to do.",tempDBname];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit data base" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Rename data base",@"Backup data base", nil];
    [alert setTag:5];
    [alert show];
}
-(void)enterInModeConsole
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter in read mode" message:@"The reading mode allows only reading the data contained in the table, you can not make changes to it. In addition, it provides better performance in handling." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Read mode", nil];
    [alert setTag:15];
    [alert show];
    
}
-(void)renameDataBaseAlert;
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rename data base" message:@"Insert the new name for the data base" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Rename", nil];
    [alert setTag:6];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

-(void)resingTableButtonsPressed:(id)sender   // RECIBE LOS BOTONES PRESIONADOS DE LA TABLA
{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.2];
    
    if ([sender tag] == 0) {
        
        // home button
        [viewHomeObj setAlpha:1.0];
        [viewTableObj setAlpha:0.0];
        [viewSecurityObj setAlpha:0.0];
        [viewTableViewOp setAlpha:0.0];
        
        [homeBtn setBackgroundColor:viewOperationsColor];
        [homeBtn setTitleColor:[UIColor colorWithRed:0 green:0.3 blue:0.6 alpha:1.0] forState:UIControlStateNormal];
        [replaceBtn setBackgroundColor:[UIColor clearColor]];
        [replaceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [SettingBtn setBackgroundColor:[UIColor clearColor]];
        [SettingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ViewBtn setBackgroundColor:[UIColor clearColor]];
        [ViewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if ([sender tag] == 1)
    {
        // table button
        [viewTableObj setAlpha:1.0];
        [viewHomeObj setAlpha:0.0];
        [viewSecurityObj setAlpha:0.0];
        [viewTableViewOp setAlpha:0.0];
        
        
        [replaceBtn setBackgroundColor:viewOperationsColor];
        [replaceBtn setTitleColor:[UIColor colorWithRed:0 green:0.3 blue:0.6 alpha:1.0] forState:UIControlStateNormal];
        [homeBtn setBackgroundColor:[UIColor clearColor]];
        [homeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [SettingBtn setBackgroundColor:[UIColor clearColor]];
        [SettingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ViewBtn setBackgroundColor:[UIColor clearColor]];
        [ViewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if ([sender tag] == 2)
    {
        // security button
        [viewSecurityObj setAlpha:1.0];
        [viewTableObj setAlpha:0.0];
        [viewHomeObj setAlpha:0.0];
        [viewTableViewOp setAlpha:0.0];
        
        [SettingBtn setBackgroundColor:viewOperationsColor];
        [SettingBtn setTitleColor:[UIColor colorWithRed:0 green:0.3 blue:0.6 alpha:1.0] forState:UIControlStateNormal];
        [homeBtn setBackgroundColor:[UIColor clearColor]];
        [homeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [replaceBtn setBackgroundColor:[UIColor clearColor]];
        [replaceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ViewBtn setBackgroundColor:[UIColor clearColor]];
        [ViewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if ([sender tag] == 3)
    {
        [viewTableViewOp setAlpha:1.0];
        [viewSecurityObj setAlpha:0.0];
        [viewTableObj setAlpha:0.0];
        [viewHomeObj setAlpha:0.0];
        // View button
        
        [ViewBtn setBackgroundColor:viewOperationsColor];
        [ViewBtn setTitleColor:[UIColor colorWithRed:0 green:0.3 blue:0.6 alpha:1.0] forState:UIControlStateNormal];
        [homeBtn setBackgroundColor:[UIColor clearColor]];
        [homeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [replaceBtn setBackgroundColor:[UIColor clearColor]];
        [replaceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [SettingBtn setBackgroundColor:[UIColor clearColor]];
        [SettingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [UIView commitAnimations];
    
     if ([sender tag] == 4)
    {
        // save button
        [self autoSavingDataBase];
        [self createAlertWithTitle:@"Successfully" Message:@"The table was save successful" CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
    }
    else if ([sender tag] == 5)
    {
        // Export button
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Export table" message:@"Select the file type in which the table will be exported." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Export as CSV file",@"Export as Onedtx file", nil];
        [alert setTag:1];
        [alert show];
    }
    else
    if ([sender tag] == 6) {
        
        // back button
        // Asignando FirstResponder a todos los textField en la tabla (evita error al salir de la tabla habiendo un campo(textfield) seleccionado).
        for (int i = 0; i < [arrayField count]; i++) {
            
            [(UITextField *)[arrayField objectAtIndex:i] resignFirstResponder];
        }
        [self autoSavingDataBase];  // Guarda la base de datos
      //  currentDataInField = @""; // evita guardar un dato en la tabla (error en indice no encontrado).
        [titleBar setText:@"Data bases"];
        SheetPath = @""; // No hay ninguna hoja de la tabla disponible
        
        [self releaseArrays];
        [self verifyAppDirectory];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.4];
        [viewTableContainer setFrame:CGRectMake(1024, 0, 1024, 768)];
        [UIView commitAnimations];
        
        [MainView setFrame:CGRectMake(-30, 0, 1024, 768)];
        [UIView beginAnimations:NULL context:NULL];   // Animacion view principal
        [UIView setAnimationDuration:0.5];
        [MainView setFrame:CGRectMake(0, 0, 1024, 768)];
        [UIView commitAnimations];
        
        [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(removeTable) userInfo:nil repeats:NO];
    }
    else if ([sender tag] == 7)
    {
        // find View operaciones btn
        if ([ModeGraphORConsol isEqualToString:consoleTableMode]) {
            
            [self createAlertWithTitle:@"Not match" Message:@"The table is in read mode." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
        else
        {
        [self findDataInFieldWithText:findTextFild.text ShowButtonSheet:YES];
        }
    }
    else if ([sender tag] == 8)
    {
        // Replace view operation btn
        if ([ModeGraphORConsol isEqualToString:consoleTableMode]) {
            
            [self createAlertWithTitle:@"Not match" Message:@"The table is in read mode." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
        else
        {
        [self replaceDataInFieldWithText:findDataTextFild.text ForData:ReplaceTextFild.text];
        }
    }
    else if ([sender tag] == 9)
    {
        // Import
        // TXT/CVS Table Loader
        if ([ModeGraphORConsol isEqualToString:consoleTableMode]) {
            
            [self createAlertWithTitle:@"Not match" Message:@"The table is in read mode." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
        else
        {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Import table" message:@"Choose the file type of the table." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Import from CSV file",@"Import from Onedtx file", nil];
        [alert setTag:2];
        [alert show];
        }
    }
    else if ([sender tag] == 10)
    {
        // New field btn
        if ([ModeGraphORConsol isEqualToString:consoleTableMode]) {
            
            [self createAlertWithTitle:@"Not match" Message:@"The table is in read mode." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
        else
        {
        DbTbviewController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:DbTbviewController animated:YES completion:NULL];
        
        NSString *primaryKey = @"";
        for (int i = 0; i < [arrayKeyBoardFieldType count]; i++) {
            
            if ([[arrayKeyBoardFieldType objectAtIndex:i] isEqualToString:@"PrimaryKeyN"] || [[arrayKeyBoardFieldType objectAtIndex:i] isEqualToString:@"PrimaryKeyA"] || [[arrayKeyBoardFieldType objectAtIndex:i] isEqualToString:@"PrimaryKey"]) { primaryKey = @"PK"; }
        }
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:tempDBname,@"DBName",tempTBname,@"TBName",[NSString stringWithFormat:@"%i",(int)fila],@"NumRows",primaryKey,@"PK", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddNewField" object:self userInfo:dic];
        }
    }
    else if ([sender tag] == 11)
    {
        // New sheet
        if ([ModeGraphORConsol isEqualToString:consoleTableMode]) {
            
            [self createAlertWithTitle:@"Not match" Message:@"The table is in read mode." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
        else
        {
       [self createSheetButtonWithSheetPanelFrame:CGRectMake(50, excelTableView.frame.size.height - 50, excelTableView.frame.size.width - 80, 50) TableName:tempTBname DataBaseName:tempDBname RootPath:oneDataDirPath InView:excelTableView ORCreateSheetButtonWithNumOfSheetButtons:/*numSheet*/[arrayBtnSheet count] FUNTION:@"CREATE SHEET BUTTON"]; // Funtion Create sheet: Crea el scroll que contendra los botones sheet y el boton principal. Funtion create sheet button: crea un boton (sheet)
        }
    }
    else if ([sender tag] == 12)
    {
        // Remove sheet
        
        if ([ModeGraphORConsol isEqualToString:consoleTableMode]) {
            
            [self createAlertWithTitle:@"Not match" Message:@"The table is in read mode." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
        else
        {
        if (![SheetPath isEqualToString:@""]) {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Are you sure you want to remove the content of this sheet?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alert show];
        [alert setTag:7];
        }
        else
        {
            [self createAlertWithTitle:@"Information" Message:@"You cannot remove this sheet. It's the main sheet." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }}
    }
    else if ([sender tag] == 13)
    {
        // edit field name
        if ([ModeGraphORConsol isEqualToString:consoleTableMode]) {
         
            [self createAlertWithTitle:@"Not match" Message:@"The table is in read mode." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
        else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit name of field" message:@"Insert the current name of the field." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Next", nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert setTag:10];
        [alert show];
        }
    }
    else if ([sender tag] == 14)
    {
        // Lock table
        [self lockTable];
    }
    else if ([sender tag] == 15)
    {
        // Unlock table
        
        if ([[self lookForTableKeyAtDBPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,tempDBname] WithTableName:tempTBname Funtion:@"GET" ForCasePOSTSetTheReferenceQuestion:nil Password:nil] count] > 0) {  // Existe una contrasena
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unlock table" message:@"Please, type your current password to confirm." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Unlock", nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [alert setTag:14];
            [alert show];
        }
        else
        {
            [self createAlertWithTitle:@"Information" Message:@"The table has not password." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
    }
    else if ([sender tag] == 16)
    {
        // make consult
        [self consultAction:quertyTextField.text ConsultType:@"SIMPLE"];
    }
    else if ([sender tag] == 17)
    {
        // Close console
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.5];
        [excelTableView setAlpha:1.0];
        [tableConsoleView setAlpha:0.0];
        [UIView commitAnimations];
        [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(removeTableConsole) userInfo:nil repeats:NO];
    }
    else if ([sender tag] == 18)
    {
        // Get database names
        arrayDataBase = [self getDataBaseNamesFromRootpath:oneDataDirPath];  // Cargando el array con el nombre de las base de datos en el dispositivo
        
        if ([arrayDataBase count] > 0) {
            
            NSString *dbNames = @"";
            for (int i = 0; i < [arrayDataBase count]; i++) {
            
                if (![[arrayDataBase objectAtIndex:i] isEqualToString:passFolderName] && ![[arrayDataBase objectAtIndex:i] isEqualToString:@"OdxQueryResults"]) {
                
                    dbNames = [dbNames stringByAppendingString:[NSString stringWithFormat:@"\n*%@",[arrayDataBase objectAtIndex:i]]];
                }
            }
            [self createAlertWithTitle:@"Databases" Message:[NSString stringWithFormat:@"List of all registered databases in the system.\n%@",dbNames] CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
        else if ([arrayDataBase count] == 0)
        {
            
            [self createAlertWithTitle:@"No databases found" Message:@"there is any database in the system." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
    }
    else if ([sender tag] == 19)
    {
        // Get tables names
        if ([arrayTables count] > 0) {
            
            NSString *tbNames = @"";
            for (int i = 0; i < [arrayTables count]; i++) {
            
                if (![[[arrayTables objectAtIndex:i] pathExtension] isEqualToString:@"Metadata"] && ![[[arrayTables objectAtIndex:i] pathExtension] isEqualToString:@"Sheet"] && ![[arrayTables objectAtIndex:i] isEqualToString:@"odxtbPasswords"] && ![[arrayTables objectAtIndex:i] isEqualToString:@"odxQueries"] && ![[arrayTables objectAtIndex:i] isEqualToString:@"OdxQueryResults"]) {
                
                    tbNames = [tbNames stringByAppendingString:[NSString stringWithFormat:@"\n*%@",[arrayTables objectAtIndex:i]]];
                }
            }
            [self createAlertWithTitle:@"Tables" Message:[NSString stringWithFormat:@"List of all registered tables in the database \"%@\".\n%@",useDatabaseTxt.text,tbNames] CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
        else if ([arrayTables count] == 0)
        {
            [self createAlertWithTitle:@"No tables found" Message:@"The current database do not have any table." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
    }
    else if ([sender tag] == 20)
    {
        // Save query result
        
        NSString *rootPath = [NSString stringWithFormat:@"%@/%@",oneDataDirPath,queryResultsFolderName];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:rootPath]) {
            
            [[NSFileManager defaultManager] createDirectoryAtPath:rootPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
        
        [self alertSetNameToQueryResultFile];
    }
}

-(void)alertSetNameToQueryResultFile
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Query results" message:@"Insert a name for the file." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    [alert setTag:17];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

# pragma GUARDA LOS RESULTADOS DE LA CONSULTA
-(void)saveQueryResultWithFileName:(NSString *)fileName QueryCommand:(NSString *)query RootPath:(NSString *)rootPath ArrayResult:(NSMutableArray *)arrayResult ArrayFieldNames:(NSMutableArray *)arrayFieldName // Guarda los resultados de las consultas (agrupados en la misma base de datos en que fueron realizadas)
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@",rootPath,queryResultsFolderName,fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil];
        
        BOOL dataSaved = [NSKeyedArchiver archiveRootObject:arrayResult toFile:[NSString stringWithFormat:@"%@/%@.data",filePath,fileName]];
        BOOL fieldNameSaved = [NSKeyedArchiver archiveRootObject:arrayFieldName toFile:[NSString stringWithFormat:@"%@/%@.fieldName",filePath,fileName]];
        BOOL queryCommandSaved = [NSKeyedArchiver archiveRootObject:query toFile:[NSString stringWithFormat:@"%@/%@.queryCommand",filePath,fileName]];
        
        if (dataSaved == YES && fieldNameSaved == YES && queryCommandSaved == YES) {
            
            [self createAlertWithTitle:@"Successful" Message:@"The query results has been save successfully." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
        else {
            [self createAlertWithTitle:@"Not match" Message:@"The datas could not be saved. Please try again later." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not match" message:@"Already exist a file with the same name, please change it and try again." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Change", nil];
        [alert setTag:18];
        [alert show];
    }
}

# pragma CARGA LOS RESULTADOS DE LA CONSULTA Y LOS MUESTRA EN LA TABLA DE RESULTADOS
-(void)loadQueryResultsFromRootPath:(NSString *)rootPath FileName:(NSString *)fileName
{
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",rootPath,queryResultsFolderName,fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        [excelTableView setAlpha:0.5];
        
        if ([ModeGraphORConsol isEqualToString:externConsultTableMode]) {
            
            [self createConsoleTableViewAtFrame:CGRectMake(0, externConsultView.frame.size.height - 350, externConsultView.frame.size.width, 350) InView:externConsultView ArrayDataField:[NSKeyedUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"%@/%@.data",path,fileName]] ArrayFieldNames:[NSKeyedUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"%@/%@.fieldName",path,fileName]] txtViewWidth:150 Alpha:0.0 ThenSetInformationIfisNeeded:[NSKeyedUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"%@/%@.queryCommand",path,fileName]]];
            
            NSLog(@"RESULT \n %@",[NSKeyedUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"%@/%@.data",path,fileName]]);
        }
        else if ([ModeGraphORConsol isEqualToString:graphicsTableMode] || [ModeGraphORConsol isEqualToString:consoleTableMode])
        {
            [self createConsoleTableViewAtFrame:CGRectMake(200, 250, 624, 388) InView:viewTableContainer ArrayDataField:[NSKeyedUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"%@/%@.data",path,fileName]] ArrayFieldNames:[NSKeyedUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"%@/%@.fieldName",path,fileName]] txtViewWidth:150 Alpha:0.0 ThenSetInformationIfisNeeded:[NSKeyedUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"%@/%@.queryCommand",path,fileName]]];
        }
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.5];
        [tableConsoleView setAlpha:1.0];
        [UIView commitAnimations];
    }
    else
    {
        [self createAlertWithTitle:@"Not match" Message:@"The file does not exist." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
    }
    [arraydataQueryResult removeAllObjects];
    [arrayFieldNameQueryResult removeAllObjects];
    
}

#pragma BUSCA EN LA RAIZ EL NOMBRE DE TODAS LAS BASES DE DATOS
-(NSArray *)getDataBaseNamesFromRootpath:(NSString *)path
{
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
}

# pragma  BUSCA LAS TABLAS QUE HAY EN LA BASE DE DATOS
-(NSArray *)getTableNamesFromDataBaseName:(NSString *)dbName RootPath:(NSString *)rootPath
{
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",rootPath,dbName] error:nil];
}

-(void)NewDataBase
{
    if (!DbTbviewController.presentingViewController && !Legal.presentingViewController && [self contractAgreementMethod:@"GET" IfitsPOSTsetChoiseOfContract:nil] == YES) {
     
    DbTbviewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:DbTbviewController animated:YES completion:NULL];
    
    // Antes de crear otra base de datos o tabla, borra todas las informaciones contenidas en los arrays para evitar errores por tener mas campos de los indicados, propiedades o datos
    [arrayFieldNames removeAllObjects];
    [arrayKeyBoardFieldType removeAllObjects];
    [arrayDataField removeAllObjects];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewDataBase" object:nil userInfo:nil];
    [self DataBases];
    }
}
-(void)NewTable
{
    DbTbviewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:DbTbviewController animated:YES completion:NULL];
    
    // Antes de crear otra base de datos o tabla, borra todas las informaciones contenidas en los arrays para evitar errores por tener mas campos de los indicados, propiedades o datos
    [arrayFieldNames removeAllObjects];
    [arrayKeyBoardFieldType removeAllObjects];
    [arrayDataField removeAllObjects];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:tempDBname,@"DBname", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewTable" object:nil userInfo:dictionary];
}
-(void)policyAndTermsOfUse
{
    Legal.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:Legal animated:YES completion:NULL];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:Policy_And_TermsOfUse,@"terms", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Legal" object:self userInfo:dic];
}
-(void)DataBases
{
    if ([ModeGraphORConsol isEqualToString:externConsultTableMode]) {  // Solo si no esta en la vista de base de datos. Vista de consulta externa
        
        ModeGraphORConsol = graphicsTableMode;  // Indica el modo en que se presentaran los datos (graficos: permite entarada de datos, y consola: modo solo lectura.
        [self releaseArrays]; // Libera todos los arrays
        [titleBar setText:@"Data bases"];
        
        if (scrollDataBase.superview) {
            
            [UIView beginAnimations:NULL context:NULL];
            [UIView setAnimationDuration:0.3];
        }else {[self verifyAppDirectory];}
        
        [externConsultView setAlpha:0.0];
        [titleExternConsultView setAlpha:0.0];
        [scrollDataBase setAlpha:1.0];
        [scrollTables setAlpha:0.0];
        [newTB setAlpha:0.0];   // nueva tabla
        [backToDataBase setAlpha:0.0];   // volver
        [BGdatabasebtn setAlpha:0.3];
        [BGquerybtn setAlpha:0.0];
        
        if (scrollDataBase.superview) { [UIView commitAnimations]; }
        
        [ckeckDatabasesAndTablesTimer invalidate]; // Permite buscar las tablas de una base de datos (usado en el modo consola: externConsultTableMode)
        
        [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(removeExternConsulteView) userInfo:nil repeats:NO];
    }
}
-(void)NewConsulte
{
    if (![ModeGraphORConsol isEqualToString:externConsultTableMode]) {
    
        queryTextRecognizerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(createQueryAssistantButton) userInfo:nil repeats:YES];
        
     //   arrayDataBase = [self getDataBaseNamesFromRootpath:oneDataDirPath];  // Cargando el array con el nombre de las base de datos en el dispositivo
        
    ModeGraphORConsol = externConsultTableMode;
    [recentQuerys removeAllObjects];
    recentQuerys = [[NSMutableArray alloc] initWithCapacity:0]; // Guardan temporalmente los querys
    
    [titleBar setText:@"New consulte"];
    titleExternConsultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleScrollDBView.frame.size.width, titleScrollDBView.frame.size.height)];
    [titleExternConsultView setAlpha:0.0];
    [titleExternConsultView setBackgroundColor:[UIColor clearColor]];
    [titleScrollDBView addSubview:titleExternConsultView];
    
    externConsultView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, MainDBView.frame.size.width, MainDBView.frame.size.height - 80)];
    [externConsultView setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.03]];
    [externConsultView setAlpha:0.0];
    [MainDBView addSubview:externConsultView];
    
    useDatabaseView = [[UIView alloc] initWithFrame:CGRectMake(15, 40, 317, 30)]; // w: 120
    [useDatabaseView setBackgroundColor:[UIColor whiteColor]];
    [titleExternConsultView addSubview:useDatabaseView];
    
    UILabel *usedb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [usedb setFont:[UIFont fontWithName:@"Heiti tc" size:11]];
    [usedb setTextColor:normalStateTableInternalBtnColor];
    [usedb setText:@"USE:"];
    [useDatabaseView addSubview:usedb];
    
    useDatabaseTxt = [[UITextField alloc] initWithFrame:CGRectMake(35, 0, 85, 30)]; // 15 60 230 30
    [useDatabaseTxt setFont:HeitiTC_12];
    [useDatabaseTxt setTextAlignment:NSTextAlignmentCenter];
    [useDatabaseTxt setBackgroundColor:viewOperationsColor];
    useDatabaseTxt.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [useDatabaseTxt setBackgroundColor:[UIColor whiteColor]];
    [useDatabaseTxt setPlaceholder:@"Data base"];
    [useDatabaseView addSubview:useDatabaseTxt];
        
    getDataBases = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [getDataBases setFrame:CGRectMake(140, 0, 20, 30)];
    [getDataBases addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [getDataBases setEnabled:NO];
    [getDataBases setTag:18];
    [useDatabaseView addSubview:getDataBases];
        
    UILabel *getDBlbl = [[UILabel alloc] initWithFrame:CGRectMake(165, 0, 60, 30)];
    [getDBlbl setFont:[UIFont fontWithName:@"Heiti tc" size:11]];
    [getDBlbl setTextColor:normalStateTableInternalBtnColor];
    [getDBlbl setText:@"Databases"];
    [useDatabaseView addSubview:getDBlbl];
        
    UIView *betweendbtb = [[UIView alloc] initWithFrame:CGRectMake(237, 0, 1, 30)];
    betweendbtb.layer.cornerRadius = 2;
    betweendbtb.layer.borderWidth = 0.3;
    betweendbtb.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [useDatabaseView addSubview:betweendbtb];
        
    getTables = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [getTables setFrame:CGRectMake(252, 0, 20, 30)];
    [getTables addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [getTables setEnabled:NO];
    [getTables setTag:19];
    [useDatabaseView addSubview:getTables];
    ckeckDatabasesAndTablesTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(gettingTablesFromDataBase) userInfo:nil repeats:YES];
        
    UILabel *getTBlbl = [[UILabel alloc] initWithFrame:CGRectMake(277, 0, 40, 30)];
    [getTBlbl setFont:[UIFont fontWithName:@"Heiti tc" size:11]];
    [getTBlbl setTextColor:normalStateTableInternalBtnColor];
    [getTBlbl setText:@"Tables"];
    [useDatabaseView addSubview:getTBlbl];
    
    UIView *queryView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, externConsultView.frame.size.width, 50)];
    [queryView setBackgroundColor:excelTableViewBGColor];
    [externConsultView addSubview:queryView];
    
    UILabel *sqllbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 40, 40)]; // 10-30
    [sqllbl setText:@"SQL"];
    [sqllbl setTextColor:normalStateTableInternalBtnColor];
    [sqllbl setFont:HeitiTC_14];
    [sqllbl setTextAlignment:NSTextAlignmentCenter];
    [sqllbl setBackgroundColor:viewOperationsColor];
    sqllbl.layer.borderWidth = 0.3;
    sqllbl.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.1].CGColor;
    [queryView addSubview:sqllbl];
    
    UIView *between5 = [[UIView alloc] initWithFrame:CGRectMake(55, 10, 1, 30)];
    between5.layer.cornerRadius = 2;
    between5.layer.borderWidth = 0.3;
    between5.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [queryView addSubview:between5];
    
    quertyTextField = [[UITextField alloc] initWithFrame:CGRectMake(56, 5, 772, 40)];
    [quertyTextField setFont:HeitiTC_14];
    [quertyTextField setTextAlignment:NSTextAlignmentCenter];
    [quertyTextField setBackgroundColor:viewOperationsColor];
    quertyTextField.layer.cornerRadius = 2;
    quertyTextField.layer.borderWidth = 0.3;
    quertyTextField.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [quertyTextField setPlaceholder:@"Example: Select field1, field2, field3, ..., fieldn from table where condition"];
    [queryView addSubview:quertyTextField];
    
    UIView *between6 = [[UIView alloc] initWithFrame:CGRectMake(828, 5, 1, 40)];
    between6.layer.cornerRadius = 2;
    between6.layer.borderWidth = 0.3;
    between6.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [queryView addSubview:between6];
    
    UIButton *makeConsult = [[UIButton alloc] initWithFrame:CGRectMake(829, 5, 93, 40)];
    [makeConsult setTitle:@"CONSULT" forState:UIControlStateNormal];
    [makeConsult setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
    [makeConsult.titleLabel setFont:HeitiTC_14];
    [makeConsult setBackgroundColor:viewOperationsColor];
    makeConsult.layer.borderWidth = 0.3;
    makeConsult.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.1].CGColor;
    [makeConsult setTag:16];
    [makeConsult addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [queryView addSubview:makeConsult];
    
    recentQueryScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, externConsultView.frame.size.width, 258)];
    [recentQueryScroll setBackgroundColor:[UIColor clearColor]];
    [externConsultView addSubview:recentQueryScroll];
    
    UIButton *saveQuery = [[UIButton alloc] initWithFrame:CGRectMake(850, 35, 40, 40)];
    [saveQuery setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    [saveQuery setTag:1];
    [saveQuery setTitleColor:[UIColor colorWithRed:0 green:0.5 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [saveQuery addTarget:self action:@selector(resingExternQueryViewButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [titleExternConsultView addSubview:saveQuery];
    
    UILabel *savelbl = [[UILabel alloc] initWithFrame:CGRectMake(895, 40, 30, 30)];
    [savelbl setFont:[UIFont fontWithName:@"Heiti tc" size:11]];
    [savelbl setTextColor:normalStateTableInternalBtnColor];
    [savelbl setText:@"SAVE"];
    [titleExternConsultView addSubview:savelbl];
        
    UIView *between = [[UIView alloc] initWithFrame:CGRectMake(840, 40, 1, 30)];
    between.layer.borderWidth = 0.3;
    between.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [titleExternConsultView addSubview:between];
        
    UIButton *loadQuery = [[UIButton alloc] initWithFrame:CGRectMake(750, 40, 35, 35)];
    [loadQuery setImage:[UIImage imageNamed:@"load.png"] forState:UIControlStateNormal];
    [loadQuery setTag:2];
    [loadQuery setTitleColor:[UIColor colorWithRed:0 green:0.5 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [loadQuery addTarget:self action:@selector(resingExternQueryViewButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [titleExternConsultView addSubview:loadQuery];
        
    UILabel *loadlbl = [[UILabel alloc] initWithFrame:CGRectMake(790, 40, 33, 30)];
    [loadlbl setFont:[UIFont fontWithName:@"Heiti tc" size:11]];
    [loadlbl setTextColor:normalStateTableInternalBtnColor];
    [loadlbl setText:@"LOAD"];
    [titleExternConsultView addSubview:loadlbl];
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.3];
    [scrollTables setAlpha:0.0];
    [scrollDataBase setAlpha:0.0];
    [externConsultView setAlpha:1.0];
    [titleExternConsultView setAlpha:1.0];
    [newTB setAlpha:0.0];   // nueva tabla
    [backToDataBase setAlpha:0.0];   // volver
    [BGdatabasebtn setAlpha:0.0];
    [BGquerybtn setAlpha:0.3];
    [UIView commitAnimations];
    }
}

# pragma CREA EL BOTON (ASISTENTE) EN EL EXTREMO DERECHO DE LA BARRA DE INSERCION DE QUERYS
-(void)createQueryAssistantButton
{
    if ([quertyTextField.text length] >= [@"insert into" length]){
        
        if ([[[quertyTextField.text substringFromIndex:([quertyTextField.text length] - [@"insert into" length])] lowercaseString] isEqualToString:@"insert into"]) { assistantForInsertion = YES; found = YES; }
    }
    else if ([quertyTextField.text length] >= [@"select" length])
    {
        if ([[[quertyTextField.text substringFromIndex:([quertyTextField.text length] - [@"select" length])] lowercaseString] isEqualToString:@"select"]) { assistantForSelection = YES; found = YES;}
    }
    else {assistantForInsertion = NO; assistantForSelection = NO; found = NO;}
    
    
    // Crea el boton Assistant
    if (found == YES && !assistant.superview) {
        
        [assistant removeFromSuperview];
        assistant = [[UIButton alloc] initWithFrame:CGRectMake(quertyTextField.frame.size.width - 80, 0, 80, quertyTextField.frame.size.height)];
        [assistant setTitle:@"ASSISTANT" forState:UIControlStateNormal];
        [[assistant titleLabel] setFont:HeitiTC_14];
        [assistant setBackgroundColor:tableInternalButtonColor];
        [assistant setAlpha:0.0];
        [assistant addTarget:self action:@selector(assistantAction) forControlEvents:UIControlEventTouchUpInside];
        [quertyTextField addSubview:assistant];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.3];
        [assistant setAlpha:1.0];
        [UIView commitAnimations];
    }
    else if (assistant.alpha == 1.0f && found == NO) {[UIView beginAnimations:NULL context:NULL]; [UIView setAnimationDuration:0.3]; [assistant setAlpha:0.0]; [UIView commitAnimations];}
    else if (assistant.alpha == 0.0f && found == YES) {[quertyTextField addSubview:assistant]; [UIView beginAnimations:NULL context:NULL]; [UIView setAnimationDuration:0.3]; [assistant setAlpha:1.0]; [UIView commitAnimations];}
    
    if (![ModeGraphORConsol isEqualToString:externConsultTableMode]) {
        [queryTextRecognizerTimer invalidate];
    }
}
# pragma BOTON ASISTENTE
-(void)assistantAction
{
    quertyTextField.enabled = NO;
    [quertyTextField setText:@""];
    
    // CREA LOS OBJETOS DEL ASISTENTE DE INSERCION DE DATOS
    if (!insertAssistantView.superview && assistantForInsertion == YES) {
     
        insertAssistantView = [[UIView alloc] initWithFrame:CGRectMake(quertyTextField.frame.origin.x, quertyTextField.frame.origin.y + 50, quertyTextField.frame.size.width, 100)];
        [insertAssistantView setBackgroundColor:viewOperationsColor];
        insertAssistantView.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.1].CGColor;
        insertAssistantView.layer.borderWidth = 0.3f;
        [insertAssistantView setAlpha:0.0];
        [externConsultView addSubview:insertAssistantView];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.5];
        [insertAssistantView setFrame:CGRectMake(quertyTextField.frame.origin.x, quertyTextField.frame.origin.y + 50, quertyTextField.frame.size.width, 100)];
        [insertAssistantView setAlpha:1.0];
        [UIView commitAnimations];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, insertAssistantView.frame.size.width, 30)];
        [title setFont:[UIFont fontWithName:@"Heiti tc" size:13]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setTextColor:normalStateTableInternalBtnColor];
        title.numberOfLines = 5;
        [title setText:@"QUERY ASSISTANT"];
        [insertAssistantView addSubview:title];
        
        info = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, insertAssistantView.frame.size.width, 20)];
        [info setFont:[UIFont fontWithName:@"Heiti tc" size:11]];
        [info setTextColor:normalStateTableInternalBtnColor];
        info.numberOfLines = 5;
        [info setText:@"Specify the name of the database and table that will be processed, then press NEXT."];
        [info setTextAlignment:NSTextAlignmentCenter];
        [insertAssistantView addSubview:info];
        
        UILabel *slash = [[UILabel alloc] initWithFrame:CGRectMake(title.center.x - 3, insertAssistantView.frame.size.height - 30, 6, 30)];
        [slash setFont:[UIFont fontWithName:@"Heiti tc" size:13]];
        [slash setTextAlignment:NSTextAlignmentCenter];
        [slash setTextColor:normalStateTableInternalBtnColor];
        [slash setText:@"/"];
        [insertAssistantView addSubview:slash];
        
        database = [[UITextField alloc] initWithFrame:CGRectMake(slash.frame.origin.x - 100, insertAssistantView.frame.size.height - 30, 90, 30)]; // 15 60 230 30
        [database setFont:HeitiTC_12];
        [database setTextAlignment:NSTextAlignmentCenter];
        [database setBackgroundColor:[UIColor clearColor]];
        database.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
        [database setPlaceholder:@"DATABASE"];
        [insertAssistantView addSubview:database];
        
        if (useDatabaseTxt.text.length > 0) {
            [database setText:useDatabaseTxt.text];
        }
        
        table = [[UITextField alloc] initWithFrame:CGRectMake(slash.frame.origin.x + 16, insertAssistantView.frame.size.height - 30, 90, 30)]; // 15 60 230 30
        [table setFont:HeitiTC_12];
        [table setTextAlignment:NSTextAlignmentCenter];
        [table setBackgroundColor:[UIColor clearColor]];
        table.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
        [table setPlaceholder:@"TABLE"];
        [insertAssistantView addSubview:table];
        
        UIButton *next = [[UIButton alloc] initWithFrame:CGRectMake(insertAssistantView.frame.size.width - 60, insertAssistantView.frame.size.height - 30, 50, 30)];
        [next setTitle:@"NEXT" forState:UIControlStateNormal];
        [[next titleLabel] setFont:[UIFont fontWithName:@"Heiti TC" size:13]];
        [next setTitleColor:tableInternalButtonColor forState:UIControlStateNormal];
        [next addTarget:self action:@selector(checkTablePassBeforeNextAssistantAction) forControlEvents:UIControlEventTouchUpInside];
        [insertAssistantView addSubview:next];
        
        UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(insertAssistantView.frame.size.width - 40, 0, 40, 40)];
        [cancel setTitle:@"X" forState:UIControlStateNormal];
        [[cancel titleLabel] setFont:[UIFont fontWithName:@"Heiti TC" size:24]];
        [cancel setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancelAssistantButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [insertAssistantView addSubview:cancel];
        
        viewForScroll = [[UIView alloc] initWithFrame:CGRectMake(0, 70, insertAssistantView.frame.size.width, 110)];
        [viewForScroll setBackgroundColor:viewOperationsColor];
        [viewForScroll setAlpha:0.0];
        [insertAssistantView addSubview:viewForScroll];
        
        assistantInsertScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewForScroll.frame.size.width, 80)];
        [assistantInsertScroll setBackgroundColor:viewOperationsColor];
        [viewForScroll addSubview:assistantInsertScroll];
        
        UIView *between = [[UIView alloc] initWithFrame:CGRectMake(viewForScroll.frame.size.width - 112, viewForScroll.frame.size.height - 30, 1, 30)];
        between.layer.borderWidth = 0.3;
        between.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
        [viewForScroll addSubview:between];
        
        UIButton *insert = [[UIButton alloc] initWithFrame:CGRectMake(viewForScroll.frame.size.width - 110, viewForScroll.frame.size.height - 30, 100, 30)];
        [insert setTitle:@"INSERT DATA" forState:UIControlStateNormal];
        [[insert titleLabel] setFont:[UIFont fontWithName:@"Heiti TC" size:13]];
        [insert setTitleColor:tableInternalButtonColor forState:UIControlStateNormal];
        [insert addTarget:self action:@selector(insertDataFromAssistant) forControlEvents:UIControlEventTouchUpInside];
        [viewForScroll addSubview:insert];
        
        autoClearSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10, insert.frame.origin.y, 40, 30)];
        autoClearSwitch.on = false;
        [viewForScroll addSubview:autoClearSwitch];
        
        UILabel * switchInfo = [[UILabel alloc] initWithFrame:CGRectMake(55, autoClearSwitch.frame.origin.y + 7, 300, 20)];
        [switchInfo setFont:[UIFont fontWithName:@"Heiti tc" size:11]];
        [switchInfo setTextColor:normalStateTableInternalBtnColor];
        switchInfo.numberOfLines = 5;
        [switchInfo setText:@"Automatically clear the fields after inserting data."];
        [switchInfo setTextAlignment:NSTextAlignmentCenter];
        [viewForScroll addSubview:switchInfo];
    }
    // CREA LOS OBJETOS PARA EL ASISTENTE DE CONSULTAS AVANZADAS
    else if (!selectAssistantView.superview && assistantForSelection == YES)
    {
        selectAssistantView = [[UIView alloc] initWithFrame:CGRectMake(quertyTextField.frame.origin.x, quertyTextField.frame.origin.y + 50, quertyTextField.frame.size.width, 100)];
        [selectAssistantView setBackgroundColor:viewOperationsColor];
        selectAssistantView.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.1].CGColor;
        selectAssistantView.layer.borderWidth = 0.3f;
        [selectAssistantView setAlpha:0.0];
        [externConsultView addSubview:selectAssistantView];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.5];
        [selectAssistantView setFrame:CGRectMake(quertyTextField.frame.origin.x, quertyTextField.frame.origin.y + 50, quertyTextField.frame.size.width, 250)];
        [selectAssistantView setAlpha:1.0];
        [UIView commitAnimations];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, selectAssistantView.frame.size.width, 30)];
        [title setFont:[UIFont fontWithName:@"Heiti tc" size:13]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setTextColor:normalStateTableInternalBtnColor];
        title.numberOfLines = 5;
        [title setText:@"QUERY ASSISTANT"];
        [selectAssistantView addSubview:title];
    
        info = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, selectAssistantView.frame.size.width, 20)];
        [info setFont:[UIFont fontWithName:@"Heiti tc" size:11]];
        [info setTextColor:normalStateTableInternalBtnColor];
        info.numberOfLines = 5;
        [info setText:@"Advance consult assistant. It run step by step, write the select consult into the fields one above other, then push NEXT"];
        [info setTextAlignment:NSTextAlignmentCenter];
        [selectAssistantView addSubview:info];
        
        UIButton *addConsult = [[UIButton alloc] initWithFrame:CGRectMake(100, 60, 40, 40)];
        [addConsult setTitle:@"+" forState:UIControlStateNormal];
        [[addConsult titleLabel] setFont:[UIFont fontWithName:@"Heiti TC" size:24]];
        [addConsult setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
        [addConsult addTarget:self action:@selector(addNewConsult) forControlEvents:UIControlEventTouchUpInside];
        [selectAssistantView addSubview:addConsult];
        
        UIButton *runQuerySet = [[UIButton alloc] initWithFrame:CGRectMake(selectAssistantView.frame.size.width - 150, 60, 150, 40)];
        [runQuerySet setTitle:@"RUN QUERY SET" forState:UIControlStateNormal];
        [[runQuerySet titleLabel] setFont:HeitiTC_12];
        [runQuerySet setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
        [runQuerySet addTarget:self action:@selector(runAdvancedQueries) forControlEvents:UIControlEventTouchUpInside];
        [selectAssistantView addSubview:runQuerySet];
        
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(objectForAssistantSelection) userInfo:nil repeats:NO];
    }
    else
    {
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.3];
        [insertAssistantView setAlpha:1.0];
        [selectAssistantView setAlpha:1.0];
        [UIView commitAnimations];
    }
}
-(void)objectForAssistantSelection
{
    selectAssistantScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, selectAssistantView.frame.size.width, selectAssistantView.frame.size.height - 100)];
    [selectAssistantScroll setBackgroundColor:[UIColor clearColor]];
    [selectAssistantScroll setContentSize:CGSizeMake(0, 0)];
    selectAssistantScroll.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.1].CGColor;
    selectAssistantScroll.layer.borderWidth = 0.3f;
    selectAssistantScroll.alpha = 0.0;
    [selectAssistantView addSubview:selectAssistantScroll];

    // Primer textField (los textField contenidos en arrayTextFieldInsertAssistant permitiran la obtencion de los querys de los mismos.)
    [self addNewConsult];
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.3];
    [selectAssistantScroll setAlpha:1.0];
    [UIView commitAnimations];
}
-(void)addNewConsult
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, (([arrayTextFieldSelectAssistant count] + 1) * 25), 300, 30)];
    [textField setFont:HeitiTC_12];
    [textField setTextAlignment:NSTextAlignmentLeft];
    [textField setBackgroundColor:[UIColor clearColor]];
    textField.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [textField setPlaceholder:@"WRITE A SIMPLE CONSULT"];
    [selectAssistantScroll addSubview:textField];
    
    UIButton *clearConsult = [[UIButton alloc] initWithFrame:CGRectMake(/*textField.frame.origin.x + textField.frame.size.width + 20*/ 10, textField.frame.origin.y + 5, 40, 10)];
    [clearConsult setTitle:@"..." forState:UIControlStateNormal];
    [[clearConsult titleLabel] setFont:[UIFont fontWithName:@"Heiti TC" size:25]];
    [clearConsult setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
    [clearConsult addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
    [clearConsult setTag:[arrayTextFieldSelectAssistant count]];
    [selectAssistantScroll addSubview:clearConsult];

    UIButton *runConsult = [[UIButton alloc] initWithFrame:CGRectMake(/*textField.frame.origin.x + textField.frame.size.width + 20*/ 50, textField.frame.origin.y, 40, 30)];
    [runConsult setTitle:@"RUN" forState:UIControlStateNormal];
    [[runConsult titleLabel] setFont:HeitiTC_12];
    [runConsult setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
    [runConsult addTarget:self action:@selector(runQuerySelected:) forControlEvents:UIControlEventTouchUpInside];
    [runConsult setTag:[arrayTextFieldSelectAssistant count]];
    [selectAssistantScroll addSubview:runConsult];

    UIView *between = [[UIView alloc] initWithFrame:CGRectMake(90, textField.frame.origin.y + 4, 1, 25)];
    between.layer.borderWidth = 0.3;
    between.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [selectAssistantScroll addSubview:between];
    
    [selectAssistantScroll setContentSize:CGSizeMake(0, (([arrayTextFieldSelectAssistant count] + 2) * 25))];
    [arrayTextFieldSelectAssistant addObject:textField];
    [arrayClearTextFieldButtons addObject:clearConsult];
}
#pragma EJECUTA EL QUERY INDICADO
-(void)runQuerySelected:(id)sender
{
    [self consultAction:[(UITextField *)[arrayTextFieldSelectAssistant objectAtIndex:[sender tag]] text] ConsultType:@"SIMPLE"];
    
    for (int i  = 0; i < [arrayClearTextFieldButtons count]; i++) {
        
        if (i != [sender tag]) {
            
            [(UIButton *)[arrayClearTextFieldButtons objectAtIndex:i] setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
        }
        else
        {
            [(UIButton *)[arrayClearTextFieldButtons objectAtIndex:i] setTitleColor:AssistantQueryIndicator forState:UIControlStateNormal];
        }
    }
}
#pragma EJECUTA EL CONJUNTO DE QUERIES (CONSULTA AVANZADA)
-(void)runAdvancedQueries
{
    NSMutableArray *arraySelections = [[NSMutableArray alloc] initWithCapacity:0];
    
    // Toma los querys contenidos en los textFields y los guarda en el array
     for (int i = 0; i < [arrayTextFieldSelectAssistant count]; i++) {
     
     [arraySelections addObject:[(UITextField *)[arrayTextFieldSelectAssistant objectAtIndex:i] text]];
     }
     
     [self makeAdvancedConsult_ArrayQuerySelections:arraySelections]; // procesa los queries indicados. Las consultas se deben efectuar en la misma tabla. Los datos a procesar en la consulta seran el resultado de la consulta anterior.
}
-(void)clearTextField:(id)sender
{
    [(UITextField *)[arrayTextFieldSelectAssistant objectAtIndex:[sender tag]] setText:@""];
    [(UIButton *)[arrayClearTextFieldButtons objectAtIndex:[sender tag]] setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
}
-(void)checkTablePassBeforeNextAssistantAction
{
    if (![database.text isEqualToString:@""] && ![table.text isEqualToString:@""]) {
        
        BOOL Exist = NO;
        
        arrayDataBase = [self getDataBaseNamesFromRootpath:oneDataDirPath];
        
        for (int i = 0; i < [arrayDataBase count]; i++) {
            
            if ([[arrayDataBase objectAtIndex:i] isEqualToString:database.text]) { Exist = YES; break; }
        }
        
        if (Exist == YES) {
            Exist = NO;
            arrayTables = [self getTableNamesFromDataBaseName:database.text RootPath:oneDataDirPath];
            
            for (int i = 0; i < [arrayTables count]; i++) {
                
                if ([[arrayTables objectAtIndex:i] isEqualToString:table.text]) { Exist = YES; break; }
            }
        }else {[self createAlertWithTitle:@"Not found" Message:@"Database not found in the system." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];}
        
        if (Exist == YES) {
            
            if ([[self lookForTableKeyAtDBPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,database.text] WithTableName:table.text Funtion:@"GET" ForCasePOSTSetTheReferenceQuestion:nil Password:nil] count] == 0) {  // Busca en la carpeta de contrasenas de la base de datos, Si no se encontro ningun archivo (nombretabla.pass) el tamano del array sera 0 indicando que la tabla no posee contrasena.
                
                [self nextAssistantButtonAction];
            }
            else  // El tamano del array es mayor que 0. (indica que la tabla posee contrasena)
            {
                [self passwordAlert];
            }
            
        }
        else{[self createAlertWithTitle:@"Not found" Message:@"Table not found in the database." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];}
    }
    else{[self createAlertWithTitle:@"Not match" Message:@"You must specify the name of the database and table effectively." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];}
    
}
# pragma NEXT (ASSISTANT)
-(void)nextAssistantButtonAction
{
    if (![database.text isEqualToString:@""] && ![table.text isEqualToString:@""]) {
        
        BOOL Exist = NO;
        
        arrayDataBase = [self getDataBaseNamesFromRootpath:oneDataDirPath];
        
        for (int i = 0; i < [arrayDataBase count]; i++) {
            
            if ([[arrayDataBase objectAtIndex:i] isEqualToString:database.text]) { Exist = YES; break; }
        }
        
        if (Exist == YES) {
            Exist = NO;
            arrayTables = [self getTableNamesFromDataBaseName:database.text RootPath:oneDataDirPath];
            
            for (int i = 0; i < [arrayTables count]; i++) {
                        
                if ([[arrayTables objectAtIndex:i] isEqualToString:table.text]) { Exist = YES; break; }
            }
        }else {[self createAlertWithTitle:@"Not found" Message:@"Database not found in the system." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];}
    
        if (Exist == YES) {
           
            [self allocTableWithDataBaseName:database.text AtPath:[NSString stringWithFormat:@"%@/%@/%@",oneDataDirPath,database.text,table.text] FUNTION:@"GET" MODE:@"NONE"];
            
            NSInteger totalWidth = 0;
            for (int i = 0; i < [arrayFieldNames count]; i++) {
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((i * 150), 0, 150, 35)];
                [label setText:[arrayFieldNames objectAtIndex:i]];
                [label setFont:[UIFont fontWithName:@"Heiti TC" size:13]];
                [label setTextColor:normalStateTableInternalBtnColor];
                [label setTextAlignment:NSTextAlignmentCenter];
                label.layer.borderWidth = 0.3f;
                label.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
                [assistantInsertScroll addSubview:label];
                
                UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(label.frame.origin.x, 35, 150, 35)];
                [textField setPlaceholder:[arrayKeyBoardFieldType objectAtIndex:i]];
                [textField setFont:[UIFont fontWithName:@"Heiti TC" size:13]];
                [textField setTextColor:normalStateTableInternalBtnColor];
                [textField setTextAlignment:NSTextAlignmentCenter];
                textField.layer.borderWidth = 0.3f;
                textField.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
                
                if ([[arrayKeyBoardFieldType objectAtIndex:i] isEqualToString:@"PrimaryKeyA"]) { [textField setPlaceholder:@"Primary key, alphabetic"]; }
                else if ([[arrayKeyBoardFieldType objectAtIndex:i] isEqualToString:@"PrimaryKeyN"]) {[textField setPlaceholder:@"Primary key, numeric"];}
                else if ([[arrayKeyBoardFieldType objectAtIndex:i] isEqualToString:@"PrimaryKey"]) {[textField setPlaceholder:@"Primary key"];}
                
                if ([[arrayKeyBoardFieldType objectAtIndex:i] isEqualToString:@"Alphabetic"] || [[arrayKeyBoardFieldType objectAtIndex:i] isEqualToString:@"PrimaryKeyA"]) {
                    
                    [textField setKeyboardType:UIKeyboardTypeDefault];
                    
                }
                else if ([[arrayKeyBoardFieldType objectAtIndex:i] isEqualToString:@"Numeric"] || [[arrayKeyBoardFieldType objectAtIndex:i] isEqualToString:@"PrimaryKeyN"])
                {
                    [textField setKeyboardType:UIKeyboardTypePhonePad];
                }
                
                [arrayTextFieldInsertAssistant addObject:textField]; // posee las entradas para cada campo
                [assistantInsertScroll addSubview:textField];
                totalWidth = ((i + 1) * 150);
            }
            
            [assistantInsertScroll setContentSize:CGSizeMake(totalWidth, 0)];
            
            [UIView beginAnimations:NULL context:NULL];
            [UIView setAnimationDuration:0.5];
            [insertAssistantView setFrame:CGRectMake(insertAssistantView.frame.origin.x, insertAssistantView.frame.origin.y, insertAssistantView.frame.size.width, insertAssistantView.frame.size.height + 90)];
            [viewForScroll setAlpha:1.0];
            [UIView commitAnimations];
            
            [info setText:@"Insert the datas for each field. If you leave empty spaces, it will be admited as a space if it support them."];
            
        }
        else{[self createAlertWithTitle:@"Not found" Message:@"Table not found in the database." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];}
    }
    else{[self createAlertWithTitle:@"Not match" Message:@"You must specify the name of the database and table effectively." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];}
    
}
# pragma CANCEL (ASSISTANT)
-(void)cancelAssistantButtonAction
{
    quertyTextField.enabled = YES;
    [quertyTextField setText:[NSString stringWithFormat:@"Insert into %@",table.text]];
    useDatabaseTxt.text = database.text;
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.3];
    [insertAssistantView setAlpha:0.0];
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(removeAssistantView) userInfo:nil repeats:NO];
}
# pragma INSERT (ASSISTANT)
-(void)insertDataFromAssistant
{
    NSMutableArray * fields = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray * data = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSInteger i = 0; i < [arrayTextFieldInsertAssistant count]; i++) {
        
        if (![[(UITextField *)[arrayTextFieldInsertAssistant objectAtIndex:i] text] isEqualToString:@""] && ![[(UITextField *)[arrayTextFieldInsertAssistant objectAtIndex:i] text] isEqualToString:@" "])
        {
            [fields addObject:[arrayFieldNames objectAtIndex:i]];
            [data addObject:[(UITextField *)[arrayTextFieldInsertAssistant objectAtIndex:i] text]];
        }
    }
    
    // inserta los valores en la tabla que estan descriptos en el query.
    [self insertIntoTable:table.text InFields:fields Values:data Database:database.text];
    
    [fields removeAllObjects];
    [data removeAllObjects];
    
    if (autoClearSwitch.on == YES) { // permite elegir si borrar o no los datos de los textField para la insercion de datos en la tabla (Asistente) despues de ser insertados.
        
        for (int i = 0; i < [arrayTextFieldInsertAssistant count]; i++) {
            
            [(UITextField *)[arrayTextFieldInsertAssistant objectAtIndex:i] setText:@""];
        }
    }
}
#pragma BORRA LA VISTA ASISTENTE
-(void)removeAssistantView
{
    [insertAssistantView removeFromSuperview];
    [selectAssistantView removeFromSuperview];
    [arrayTextFieldInsertAssistant removeAllObjects];
    [arrayTextFieldSelectAssistant removeAllObjects];
    [arrayClearTextFieldButtons removeAllObjects];
    
}

# pragma BUSCA LAS TABLAS DE LA BASE DE DATOS ESPECIFICADA (useDatabaseTxt)
-(void)gettingTablesFromDataBase
{
    if ([ModeGraphORConsol isEqualToString:externConsultTableMode]) {
    
        if ([useDatabaseTxt.text length] > 0 ) {
        
            arrayTables = [self getTableNamesFromDataBaseName:useDatabaseTxt.text RootPath:oneDataDirPath];
    
            if ([arrayTables count] > 0 ) {
                
                if (![[[arrayTables objectAtIndex:0] pathExtension] isEqualToString:@"Metadata"] && ![[[arrayTables objectAtIndex:0] pathExtension] isEqualToString:@"Sheet"] && ![[arrayTables objectAtIndex:0] isEqualToString:@"odxtbPasswords"] && ![[arrayTables objectAtIndex:0] isEqualToString:@"odxQueries"] && ![[arrayTables objectAtIndex:0] isEqualToString:@"OdxQueryResults"]) {
                    
                    [getTables setEnabled:YES];
                }
                else{ [getTables setEnabled:NO]; }
                
            } else {[getTables setEnabled:NO];}
    }}
    else if ([ModeGraphORConsol isEqualToString:graphicsTableMode] || [ModeGraphORConsol isEqualToString:consoleTableMode])
    {
        [ckeckDatabasesAndTablesTimer invalidate];
    }
    
    [self gettingDatabases];
}
# pragma BUSCA LAS BASE DE DATOS EXISTENTES EN EL SISTEMA
-(void)gettingDatabases
{
    if ([ModeGraphORConsol isEqualToString:externConsultTableMode]) {
        
        if ([useDatabaseTxt.text length] == 0 ) {
            
            arrayDataBase = [self getDataBaseNamesFromRootpath:oneDataDirPath];  // Cargando el array con el nombre de las base de datos en el dispositivo
            
            if ([arrayDataBase count] > 0) {
                
                for (int i = 0; i < [arrayDataBase count]; i++) {
                    
                    if (![[arrayDataBase objectAtIndex:i] isEqualToString:passFolderName] && ![[arrayDataBase objectAtIndex:i] isEqualToString:@"OdxQueryResults"]) {
                        
                        [getDataBases setEnabled:YES];
                    }
                }
            }
            else { [getDataBases setEnabled:NO]; }
        }
    }
}

-(void)resingBarTablesAction:(id)sender  // RECIBE LAS ACCIONES DE LOS BOTONES DE LA BARRA TB. En vista scroll tables
{
    if ([sender tag] == 0) {  // boton atras. Retrocede desde el scroll de tablas a el scroll de base de datos
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.3];
        [scrollTables setAlpha:0.0];
        [scrollDataBase setAlpha:1.0];
        [newTB setAlpha:0.0];   // nueva tabla
        [backToDataBase setAlpha:0.0];   // volver
        [UIView commitAnimations];
        
        [titleBar setText:@"Data bases"];
        
        [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(removeScrollTables) userInfo:nil repeats:NO];
    }
}

#define passFolderName @"odxtbPasswords"
#define tablePasswordExtention @"pass"
# pragma BUSCA LA CONTRASENA DE UNA TABLA A PARTIR DE SU RUTA (FUNTION: GET/POST/DELETE)
-(NSMutableArray *)lookForTableKeyAtDBPath:(NSString *)dbPath WithTableName:(NSString *)tbName Funtion:(NSString *)funtion ForCasePOSTSetTheReferenceQuestion:(NSString *)refQuestion Password:(NSString *)password
{
    NSString *passFolderPath = [NSString stringWithFormat:@"%@/%@",dbPath,passFolderName]; // Carpeta de contrasenas localizada dentro de la base de datos. La carpeta guardara archivos con el mismo nombre de la tabla.pass
    
    NSString *passTableFilePath = [NSString stringWithFormat:@"%@/%@.%@",passFolderPath,tbName,tablePasswordExtention];  // Ruta de el archivo en busqueda. (nomtabla.pass)
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:passFolderPath]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:passFolderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSMutableArray *arrayResult = [[NSMutableArray alloc] initWithCapacity:0];
    
    if ([funtion isEqualToString:@"GET"]) {
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:passTableFilePath] && [[self loadTableAtPath:passTableFilePath] count] > 0) {  // En caso de no existir el archivo, el tamano del array sera 0 lo cual permitira invocar la tabla
            
            arrayResult = [self loadTableAtPath:passTableFilePath];
        }
    }
    else if ([funtion isEqualToString:@"POST"])
    {
        [arrayResult addObject:refQuestion];  // indice 0
        [arrayResult addObject:password];  // Indice 1
        
        BOOL success = [NSKeyedArchiver archiveRootObject:arrayResult toFile:passTableFilePath];
        if (success == NO) {
            
            [self createAlertWithTitle:@"Information" Message:@"The password cannot be set, please try again later." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
        else
        {
            [tablePassStatusImg setImage:[UIImage imageNamed:@"tableLocked.png"]];
            [passwordTextField setText:@""];
            [refWordTextField setText:@""];
        }
    }
    else if ([funtion isEqualToString:@"DELETE"])
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:passTableFilePath]) {
            
         BOOL removed = [[NSFileManager defaultManager] removeItemAtPath:passTableFilePath error:nil];
            
            if (removed == YES) {
                
                [tablePassStatusImg setImage:[UIImage imageNamed:@"tableUnlocked.png"]];
            }
            else
            {
                [self createAlertWithTitle:@"Information" Message:@"The password cannot be removed, please try again later." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
            }
        }
        else  // No hay contrasena
        {
            [self createAlertWithTitle:@"Information" Message:@"The table do not have password." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
    }
    
    return arrayResult;
}

# pragma BLOQUEA LA TABLA ACTUAL
-(void)lockTable
{
    if (![refWordTextField.text isEqualToString:@""] && ![passwordTextField.text isEqualToString:@""]) {
        
        if ([[self lookForTableKeyAtDBPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,tempDBname] WithTableName:tempTBname Funtion:@"GET" ForCasePOSTSetTheReferenceQuestion:nil Password:nil] count] > 0) { // Existe una contrasena
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"There is a password, do you want to overwrite it?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
            [alert setTag:12];
            [alert show];
        }
        else // No existe contrasena (la tabla no posee contrasena Count = 0)
        {
            [self lookForTableKeyAtDBPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,tempDBname] WithTableName:tempTBname Funtion:@"POST" ForCasePOSTSetTheReferenceQuestion:refWordTextField.text Password:passwordTextField.text];
            
            // contrasena guardada en la ruta de la base de datos donde se encuentra la tabla, en la carpeta (password) archivo: nombretabla.pass
        }
    }
    else
    {
        [self createAlertWithTitle:@"Not match" Message:@"You have not entered the password correctly." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
    }
}

# pragma DESBLOQUEA LA TABLA ACTUAL
-(void)unLockTable
{
    [self lookForTableKeyAtDBPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,tempDBname] WithTableName:tempTBname Funtion:@"DELETE" ForCasePOSTSetTheReferenceQuestion:nil Password:nil];
}

# pragma INVOCA LA TABLA CON SU METADATO A PARTIR DE UNA RUTA Y EL NOMBRE DE LA BASE DE DATOS. (FUNTION: CREATE / UPDATE) (MODE: GRAPHICS / CONSOLE)
-(void)allocTableWithDataBaseName:(NSString *)name AtPath:(NSString *)TablePath FUNTION:(NSString *)funtion MODE:(NSString *)mode // Carga las tablas a partir del nombre de la base de datos y su ruta. Las variabes y los arrays estaticos guardan el contenido cargado durante todo el tiempo de uso para, si es necesario guardar, mantener todos los contenidos y la misma ruta. Permite actualizar la tabla cuando el usuario crea un nuevo campo
{
    NSMutableArray *TableData = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *TableMetadata = [[NSMutableArray alloc] initWithCapacity:0];
    
    TableData = [self loadTableAtPath:TablePath];
    TableMetadata = [self loadTableAtPath:[NSString stringWithFormat:@"%@.Metadata",TablePath]];
    
    DBName = name;
    DBTableName = [TableData objectAtIndex:0];
    arrayFieldNames = [TableData objectAtIndex:1];
    arrayDataField = [TableData objectAtIndex:2];
    numOfColField = [[TableMetadata objectAtIndex:0] intValue];
    arrayKeyBoardFieldType = [TableMetadata objectAtIndex:1];
    
    [arrayField removeAllObjects];  // Borra los campos anteriores
    
    if ([funtion isEqualToString:@"CREATE"]) {
        // 140 / 628
        
        [self createExcelTableWithName:DBTableName ColFieldNames:arrayFieldNames PlaceIn:CGRectMake(0, 180, 1024, 588) InView:self.view Alpha:1.0 ThenCreateNumFieldsInX:[arrayFieldNames count] FieldsInY:numOfColField WithWidth:150 AndHeight:30 SpaceSize:0 AndKeyBoardType:arrayKeyBoardFieldType willCREATEorUPDATE:funtion modeINPUTorOUTPUT:mode];
        
        [self calculateProgressCapacityTableForNumField:[arrayField count] FieldNotEmpty:0 ArrayData:arrayDataField GETFuntion:@"ARRAY"];  // Indica el espacio libre de la tabla
        
    }
    else if ([funtion isEqualToString:@"UPDATE"])
    {
        [self createExcelTableWithName:DBTableName ColFieldNames:arrayFieldNames PlaceIn:CGRectMake(0, 180, 1024, 588) InView:self.view Alpha:1.0 ThenCreateNumFieldsInX:[arrayFieldNames count] FieldsInY:numOfColField WithWidth:150 AndHeight:30 SpaceSize:0 AndKeyBoardType:arrayKeyBoardFieldType willCREATEorUPDATE:funtion modeINPUTorOUTPUT:mode];
    }
    
    if (([funtion isEqualToString:@"CREATE"] || [funtion isEqualToString:@"UPDATE"]) && [mode isEqualToString:graphicsTableMode]) {
     
        [self autoSetDataFromArray:arrayDataField InFieldForArrayFields:arrayField]; // Inserta los datos del arrayDataField en cada textField
    }
}

# pragma ACTUALIZA LA TABLA
-(void)updateTableWithNewFields
{
    [self autoSavingDataBase];
  // MODO SOLO LECTURA (console mode): no permite realizar cambios en la tabla.

    [arrayDataField removeAllObjects];
    [arrayOBfieldNames removeAllObjects];
    [arrayOBNumRows removeAllObjects];
    [arrayDataFound removeAllObjects];
    [excelTableView removeFromSuperview];
    
    [self allocTableWithDataBaseName:tempDBname AtPath:[NSString stringWithFormat:@"%@/%@/%@",oneDataDirPath,tempDBname,tempTBname] FUNTION:@"UPDATE" MODE:ModeGraphORConsol];  // Cargando tabla de la DB y TB seleccionadas. (FUNTION: indica si creara o actualizara la tabla)
}

-(void)createTableObjetcs
{
    UIView *barTableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 80)];
    [barTableView setBackgroundColor:barColor];
    [viewTableContainer addSubview:barTableView];
    
    UILabel *TBName = [[UILabel alloc] initWithFrame:CGRectMake(435,23, 155, 21)];
    [TBName setText:tempTBname];
    [TBName setTextColor:[UIColor whiteColor]];
    [TBName setFont:HeitiTC_12];
    [TBName setTextAlignment:NSTextAlignmentCenter];
    [barTableView addSubview:TBName];
    
    homeBtn = [[UIButton alloc] initWithFrame:CGRectMake(385, 48, 60, 33)];
    [homeBtn setTitle:@"HOME" forState:UIControlStateNormal];
    [homeBtn setBackgroundColor:viewOperationsColor];
    [homeBtn setTitleColor:[UIColor colorWithRed:0 green:0.3 blue:0.6 alpha:1.0] forState:UIControlStateNormal];
    [[homeBtn titleLabel] setFont:MenuBarTbHTC_14];
    [[homeBtn titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [homeBtn setTag:0];
    [homeBtn.layer setCornerRadius:2];
    [homeBtn addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [barTableView addSubview:homeBtn];
    
    replaceBtn = [[UIButton alloc] initWithFrame:CGRectMake(445, 48, 60, 33)];
    [replaceBtn setTitle:@"TABLE" forState:UIControlStateNormal];
    [replaceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[replaceBtn titleLabel] setFont:MenuBarTbHTC_14];
    [[replaceBtn titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [replaceBtn setTag:1];
    [replaceBtn.layer setCornerRadius:2.0];
    [replaceBtn addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [barTableView addSubview:replaceBtn];
    
    SettingBtn = [[UIButton alloc] initWithFrame:CGRectMake(505, 48, 80, 33)];
    [SettingBtn setTitle:@"SECURITY" forState:UIControlStateNormal];
    [SettingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[SettingBtn titleLabel] setFont:MenuBarTbHTC_14];
    [[SettingBtn titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [SettingBtn setTag:2];
    [SettingBtn.layer setCornerRadius:2.0];
    [SettingBtn addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [barTableView addSubview:SettingBtn];
    
    ViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(585, 48, 58, 33)];
    [ViewBtn setTitle:@"MORE" forState:UIControlStateNormal];
    [ViewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[ViewBtn titleLabel] setFont:MenuBarTbHTC_14];
    [[ViewBtn titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [ViewBtn setTag:3];
    [ViewBtn.layer setCornerRadius:2.0];
    [ViewBtn addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [barTableView addSubview:ViewBtn];
    
    UIButton *BackBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 40, 35, 35)];
    [BackBtn setImage:[UIImage imageNamed:@"back from table.png"] forState:UIControlStateNormal];
    [BackBtn setTag:6];
    [BackBtn addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [barTableView addSubview:BackBtn];
    
    
    // BARRA DE OPERACIONES (HOME)

    viewHomeObj = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 1024, 50)];
    [viewHomeObj setBackgroundColor:viewOperationsColor];
    [viewHomeObj setAlpha:1.0];
    viewHomeObj.layer.borderWidth = 0.3;
    viewHomeObj.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [viewTableContainer addSubview:viewHomeObj];
    
    UIButton *txtTableLoaderBtn = [[UIButton alloc] initWithFrame:CGRectMake(85, 5, 35, 35)];
    [txtTableLoaderBtn setImage:[UIImage imageNamed:@"import.png"] forState:UIControlStateNormal];
    [txtTableLoaderBtn setTag:9];
    [txtTableLoaderBtn addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [viewHomeObj addSubview:txtTableLoaderBtn];
    
    UILabel *importLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 70, 35)];
    [importLabel setText:@"IMPORT"];
    [importLabel setTextColor:normalStateTableInternalBtnColor];
    [importLabel setFont:OperationBarFontHTC_11];
    [viewHomeObj addSubview:importLabel];
    
    UIButton *ShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 10, 30, 30)];
    [ShareBtn setImage:[UIImage imageNamed:@"export.png"] forState:UIControlStateNormal];
    [ShareBtn setTag:5];
    [ShareBtn addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [viewHomeObj addSubview:ShareBtn];
    
    UILabel *exportLabel = [[UILabel alloc] initWithFrame:CGRectMake(235, 10, 70, 35)];
    [exportLabel setText:@"EXPORT"];
    [exportLabel setTextColor:normalStateTableInternalBtnColor];
    [exportLabel setFont:OperationBarFontHTC_11];
    [viewHomeObj addSubview:exportLabel];
    
    UIView *between3 = [[UIView alloc] initWithFrame:CGRectMake(293, 10, 1, 30)];
    between3.layer.borderWidth = 0.3;
    between3.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [viewHomeObj addSubview:between3];
    
    UIButton *newField = [[UIButton alloc] initWithFrame:CGRectMake(310, 10, 30, 30)];  // Agregar nuevo campo
    [newField setImage:[UIImage imageNamed:@"createField.png"] forState:UIControlStateNormal];
    [newField setTag:10];
    [newField addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [viewHomeObj addSubview:newField];
    
    UILabel *newFieldLabel = [[UILabel alloc] initWithFrame:CGRectMake(345, 10, 70, 35)];
    [newFieldLabel setText:@"CREATE FIELD"];
    [newFieldLabel setTextColor:normalStateTableInternalBtnColor];
    [newFieldLabel setFont:OperationBarFontHTC_11];
    [viewHomeObj addSubview:newFieldLabel];
    
    UIButton *editFieldNameBtn = [[UIButton alloc] initWithFrame:CGRectMake(445, 10, 30, 30)];  // Agregar nueva hoja
    [editFieldNameBtn setImage:[UIImage imageNamed:@"editFieldName.png"] forState:UIControlStateNormal];
    [editFieldNameBtn setTag:13];
    [editFieldNameBtn addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [viewHomeObj addSubview:editFieldNameBtn];
    
    UILabel *editFieldNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(480, 10, 100, 35)];
    [editFieldNameLabel setText:@"EDIT FIELD NAME"];
    [editFieldNameLabel setTextColor:normalStateTableInternalBtnColor];
    [editFieldNameLabel setFont:OperationBarFontHTC_11];
    [viewHomeObj addSubview:editFieldNameLabel];
    
    UIView *between4 = [[UIView alloc] initWithFrame:CGRectMake(583, 10, 1, 30)];
    between4.layer.borderWidth = 0.3;
    between4.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [viewHomeObj addSubview:between4];
    
    UIButton *newSheet = [[UIButton alloc] initWithFrame:CGRectMake(595, 10, 30, 30)];  // Agregar nueva hoja
    [newSheet setImage:[UIImage imageNamed:@"newSheet.png"] forState:UIControlStateNormal];
    [newSheet setTag:11];
    [newSheet addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [viewHomeObj addSubview:newSheet];
    
    UILabel *newSheetLabel = [[UILabel alloc] initWithFrame:CGRectMake(630, 10, 70, 35)];
    [newSheetLabel setText:@"NEW SHEET"];
    [newSheetLabel setTextColor:normalStateTableInternalBtnColor];
    [newSheetLabel setFont:OperationBarFontHTC_11];
    [viewHomeObj addSubview:newSheetLabel];
    
    [self createEraseSheetBtnWithFrame:CGRectMake(710, 10, 30, 30) InView:viewHomeObj];
    
    UILabel *EraseBtnLabel = [[UILabel alloc] initWithFrame:CGRectMake(745, 10, 80, 35)];
    [EraseBtnLabel setText:@"REMOVE SHEET"];
    [EraseBtnLabel setTextColor:normalStateTableInternalBtnColor];
    [EraseBtnLabel setFont:OperationBarFontHTC_11];
    [viewHomeObj addSubview:EraseBtnLabel];
    
    UIButton *SaveBtn = [[UIButton alloc] initWithFrame:CGRectMake(850, 5, 40, 40)];
    [SaveBtn setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    [SaveBtn setTag:4];
    [SaveBtn addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [viewHomeObj addSubview:SaveBtn];
    
    UILabel *saveLabel = [[UILabel alloc] initWithFrame:CGRectMake(895, 10, 70, 35)];
    [saveLabel setText:@"SAVE"];
    [saveLabel setTextColor:normalStateTableInternalBtnColor];
    [saveLabel setFont:OperationBarFontHTC_11];
    [viewHomeObj addSubview:saveLabel];
    
    
    // TABLE
    
    viewTableObj = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 1024, 50)];
    [viewTableObj setBackgroundColor:viewOperationsColor];
    [viewTableObj setAlpha:0.0];
    viewTableObj.layer.borderWidth = 0.3;
    viewTableObj.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [viewTableContainer addSubview:viewTableObj];
    
    UILabel *findLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, 30, 35)];
    [findLabel setText:@"FIND:"];
    [findLabel setTextColor:normalStateTableInternalBtnColor];
    [findLabel setFont:OperationBarFontHTC_11];
    [viewTableObj addSubview:findLabel];
    
    findTextFild = [[UITextField alloc] initWithFrame:CGRectMake(95, 10, 300, 30)];
    [findTextFild setFont:HeitiTC_14];
    [findTextFild setTextAlignment:NSTextAlignmentCenter];
    [findTextFild setBackgroundColor:[UIColor whiteColor]];
    findTextFild.layer.cornerRadius = 5;
    findTextFild.layer.borderWidth = 0.3;
    findTextFild.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.4].CGColor;
    [findTextFild setPlaceholder:@"Search in the table"];
    [viewTableObj addSubview:findTextFild];
    
    UIButton *findTBtn = [[UIButton alloc] initWithFrame:CGRectMake(405, 10, 30, 30)];
    [findTBtn setImage:[UIImage imageNamed:@"find.png"] forState:UIControlStateNormal];
    [findTBtn setTag:7];
    [findTBtn addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [viewTableObj addSubview:findTBtn];
    
    UIView *between = [[UIView alloc] initWithFrame:CGRectMake(470, 10, 1, 30)];
    between.layer.borderWidth = 0.3;
    between.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [viewTableObj addSubview:between];
    
    UILabel *repLabel = [[UILabel alloc] initWithFrame:CGRectMake(505, 10, 55, 35)];
    [repLabel setText:@"REPLACE:"];
    [repLabel setTextColor:normalStateTableInternalBtnColor];
    [repLabel setFont:OperationBarFontHTC_11];
    [viewTableObj addSubview:repLabel];
    
    findDataTextFild = [[UITextField alloc] initWithFrame:CGRectMake(570, 10, 150, 30)];
    [findDataTextFild setFont:HeitiTC_14];
    [findDataTextFild setTextAlignment:NSTextAlignmentCenter];
    [findDataTextFild setBackgroundColor:[UIColor whiteColor]];
    findDataTextFild.layer.cornerRadius = 5;
    findDataTextFild.layer.borderWidth = 0.3;
    findDataTextFild.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.4].CGColor;
    [findDataTextFild setPlaceholder:@"Data to replace"];
    [viewTableObj addSubview:findDataTextFild];
    
    UILabel *withLabel = [[UILabel alloc] initWithFrame:CGRectMake(730, 10, 30, 35)];
    [withLabel setText:@"WITH:"];
    [withLabel setTextColor:normalStateTableInternalBtnColor];
    [withLabel setFont:OperationBarFontHTC_11];
    [viewTableObj addSubview:withLabel];
    
    ReplaceTextFild = [[UITextField alloc] initWithFrame:CGRectMake(770, 10, 150, 30)];
    [ReplaceTextFild setFont:HeitiTC_14];
    [ReplaceTextFild setTextAlignment:NSTextAlignmentCenter];
    [ReplaceTextFild setBackgroundColor:[UIColor whiteColor]];
    ReplaceTextFild.layer.cornerRadius = 5;
    ReplaceTextFild.layer.borderWidth = 0.3;
    ReplaceTextFild.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.4].CGColor;
    [ReplaceTextFild setPlaceholder:@"Replace with data"];
    [viewTableObj addSubview:ReplaceTextFild];
   
    UIButton *ReplaceTBtn = [[UIButton alloc] initWithFrame:CGRectMake(930, 10, 30, 30)];
    [ReplaceTBtn setImage:[UIImage imageNamed:@"replace.png"] forState:UIControlStateNormal];
    [ReplaceTBtn setTag:8];
    [ReplaceTBtn addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [viewTableObj addSubview:ReplaceTBtn];
    
    
    // SECURITY
    
    viewSecurityObj = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 1024, 50)];
    [viewSecurityObj setBackgroundColor:viewOperationsColor];
    [viewSecurityObj setAlpha:0.0];
    viewSecurityObj.layer.borderWidth = 0.3;
    viewSecurityObj.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [viewTableContainer addSubview:viewSecurityObj];
    
    UILabel *rwLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 110, 35)];
    [rwLabel setText:@"REFERENCE WORD:"];
    [rwLabel setTextColor:normalStateTableInternalBtnColor];
    [rwLabel setFont:OperationBarFontHTC_11];
    [viewSecurityObj addSubview:rwLabel];
    
    refWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(170, 10, 300, 30)];
    [refWordTextField setFont:HeitiTC_14];
    [refWordTextField setTextAlignment:NSTextAlignmentCenter];
    [refWordTextField setBackgroundColor:[UIColor whiteColor]];
    refWordTextField.layer.cornerRadius = 5;
    refWordTextField.layer.borderWidth = 0.3;
    refWordTextField.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.4].CGColor;
    [refWordTextField setPlaceholder:@"Reference word"];
    [viewSecurityObj addSubview:refWordTextField];
    
    UILabel *passLabel = [[UILabel alloc] initWithFrame:CGRectMake(490, 10, 70, 35)];
    [passLabel setText:@"PASSWORD:"];
    [passLabel setTextColor:normalStateTableInternalBtnColor];
    [passLabel setFont:OperationBarFontHTC_11];
    [viewSecurityObj addSubview:passLabel];
    
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(570, 10, 200, 30)];
    [passwordTextField setFont:HeitiTC_14];
    [passwordTextField setTextAlignment:NSTextAlignmentCenter];
    [passwordTextField setBackgroundColor:[UIColor whiteColor]];
    passwordTextField.layer.cornerRadius = 5;
    passwordTextField.layer.borderWidth = 0.3;
    passwordTextField.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.4].CGColor;
    [passwordTextField setPlaceholder:@"Password"];
    [viewSecurityObj addSubview:passwordTextField];
    
    UIButton *LockTBtn = [[UIButton alloc] initWithFrame:CGRectMake(780, 10, 30, 30)];
    [LockTBtn setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
    [LockTBtn setTag:14];
    [LockTBtn addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [viewSecurityObj addSubview:LockTBtn];
    
    UILabel *lockLabel = [[UILabel alloc] initWithFrame:CGRectMake(820, 10, 35, 35)];
    [lockLabel setText:@"LOCK"];
    [lockLabel setTextColor:normalStateTableInternalBtnColor];
    [lockLabel setFont:OperationBarFontHTC_11];
    [viewSecurityObj addSubview:lockLabel];
    
    UIView *between2 = [[UIView alloc] initWithFrame:CGRectMake(865, 10, 1, 30)];
    between2.layer.borderWidth = 0.3;
    between2.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [viewSecurityObj addSubview:between2];
    
    UIButton *unLockTBtn = [[UIButton alloc] initWithFrame:CGRectMake(875, 10, 30, 30)];
    [unLockTBtn setImage:[UIImage imageNamed:@"unlock.png"] forState:UIControlStateNormal];
    [unLockTBtn setTag:15];
    [unLockTBtn addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [viewSecurityObj addSubview:unLockTBtn];
    
    UILabel *unlockLabel = [[UILabel alloc] initWithFrame:CGRectMake(915, 10, 50, 35)];
    [unlockLabel setText:@"UNLOCK"];
    [unlockLabel setTextColor:normalStateTableInternalBtnColor];
    [unlockLabel setFont:OperationBarFontHTC_11];
    [viewSecurityObj addSubview:unlockLabel];
    
    
    // QUERY VIEW
    
    UIView *queryView = [[UIView alloc] initWithFrame:CGRectMake(0, 130, 1024, 50)];
    [queryView setBackgroundColor:excelTableViewBGColor];
    [queryView setAlpha:1.0];
    [viewTableContainer addSubview:queryView];
    
    UILabel *sqllbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 40, 29)];
    [sqllbl setText:@"SQL"];
    [sqllbl setTextColor:normalStateTableInternalBtnColor];
    [sqllbl setFont:OperationBarFontHTC_11];
    [sqllbl setTextAlignment:NSTextAlignmentCenter];
    [sqllbl setBackgroundColor:viewOperationsColor];
    sqllbl.layer.borderWidth = 0.3;
    sqllbl.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.1].CGColor;
    [queryView addSubview:sqllbl];
    
    UIView *between5 = [[UIView alloc] initWithFrame:CGRectMake(55, 10, 1, 29)];
    between5.layer.cornerRadius = 2;
    between5.layer.borderWidth = 0.3;
    between5.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [queryView addSubview:between5];
    
    quertyTextField = [[UITextField alloc] initWithFrame:CGRectMake(56, 10, 843, 29)];
    [quertyTextField setFont:HeitiTC_14];
    [quertyTextField setTextAlignment:NSTextAlignmentCenter];
    [quertyTextField setBackgroundColor:viewOperationsColor];
    quertyTextField.layer.cornerRadius = 2;
    quertyTextField.layer.borderWidth = 0.3;
    quertyTextField.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [quertyTextField setPlaceholder:@"Example: Select field1, field2, field3, ..., fieldn from table where condition"];
    [queryView addSubview:quertyTextField];
    
    UIView *between6 = [[UIView alloc] initWithFrame:CGRectMake(899, 10, 1, 29)];
    between6.layer.cornerRadius = 2;
    between6.layer.borderWidth = 0.3;
    between6.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [queryView addSubview:between6];
    
    UIButton *makeConsult = [[UIButton alloc] initWithFrame:CGRectMake(900, 10, 105, 29)];
    [makeConsult setTitle:@"CONSULT" forState:UIControlStateNormal];
    [makeConsult setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
    [makeConsult.titleLabel setFont:OperationBarFontHTC_11];
    [makeConsult setBackgroundColor:viewOperationsColor];
    makeConsult.layer.borderWidth = 0.3;
    makeConsult.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.1].CGColor;
    [makeConsult setTag:16];
    [makeConsult addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [queryView addSubview:makeConsult];
    
    // TABLE VIEW
    viewTableViewOp = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 1024, 50)];
    [viewTableViewOp setBackgroundColor:viewOperationsColor];
    [viewTableViewOp setAlpha:0.0];
    viewTableViewOp.layer.borderWidth = 0.3;
    viewTableViewOp.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [viewTableContainer addSubview:viewTableViewOp];
    
    UIView *between7 = [[UIView alloc] initWithFrame:CGRectMake(viewTableViewOp.frame.size.width - 180, 10, 1, 29)];
    between7.layer.cornerRadius = 2;
    between7.layer.borderWidth = 0.3;
    between7.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [viewTableViewOp addSubview:between7];
    
    UILabel *grapReadMode = [[UILabel alloc] initWithFrame:CGRectMake(viewTableViewOp.frame.size.width - 105, 10, 70, 35)];
    [grapReadMode setText:@"READ MODE"];
    [grapReadMode setTextColor:normalStateTableInternalBtnColor];
    [grapReadMode setFont:OperationBarFontHTC_11];
    [viewTableViewOp addSubview:grapReadMode];
    
    useConsoleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(viewTableViewOp.frame.size.width - 165, 10, 40, 30)];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:tableModeFileName] isEqualToString:consoleTableMode]) { [useConsoleSwitch setOn:YES]; } else { [useConsoleSwitch setOn:NO]; } // Si no encuentra una configuracion establecida, carga la tabla en modo grafico por defecto.
    [useConsoleSwitch addTarget:self action:@selector(setTableMode) forControlEvents:UIControlEventValueChanged];
    [viewTableViewOp addSubview:useConsoleSwitch];
    
    UILabel *tbCapacity = [[UILabel alloc] initWithFrame:CGRectMake(viewTableViewOp.frame.size.width - 665, 10, 90, 35)];
    [tbCapacity setText:@"TABLE CAPACITY"];
    [tbCapacity setTextColor:normalStateTableInternalBtnColor];
    [tbCapacity setFont:OperationBarFontHTC_11];
    [viewTableViewOp addSubview:tbCapacity];
    
    // TABLE CAPACITY PROGRESSVIEW
    capacityTable = [[UIProgressView alloc] initWithFrame:CGRectMake(30, 45, viewTableViewOp.frame.size.width - 245, 10)];
    [capacityTable setProgress:0];
    [capacityTable setProgressViewStyle:UIProgressViewStyleDefault];
    [capacityTable setTintColor:barColor];
    [capacityTable setBackgroundColor:[UIColor whiteColor]];
    [viewTableViewOp addSubview:capacityTable];
    
}
-(void)setTableMode
{
     NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if (useConsoleSwitch.on) {
        
        [userDefault setObject:consoleTableMode forKey:tableModeFileName];
    }
    else
    {
        [userDefault setObject:graphicsTableMode forKey:tableModeFileName];
    }
}

# pragma PROCESA LA CONSULTA INDICADA. CONSULT TYPE: SIMPLE/ADVANCED
-(void)consultAction:(NSString *)query ConsultType:(NSString *)consultType
{
    queryDictionary = [QueryClass query:query]; // Procesa el query y obtiene sus entidades
    
    //NSLog(@"--- %@",queryDictionary);
    
# pragma REALIZA LAS CONSULTAS (SELECT)
    if ([[queryDictionary objectForKey:@"sentence"] isEqualToString:@"select"]) {  // BUSCAR EN LA TABLA
        
        if ([[queryDictionary objectForKey:@"ConsultType"] isEqualToString:@"Advanced"]) { // SELECT IN (SELECT ...)
            
            NSLog(@"CONSULTA AVANZADA (%i queries)",(int)[[queryDictionary objectForKey:@"queries"] count]);
            [self selectInSelections:[queryDictionary objectForKey:@"queries"] database:useDatabaseTxt.text];
        }
        else if ([[queryDictionary objectForKey:@"ConsultType"] isEqualToString:@"Simple"]) // SELECT CAMPOS FROM TABLA WHERE CAMPO OPERADOR VALUE
        {
            NSLog(@"CONSULTA SIMPLE");

        [tableConsoleView removeFromSuperview];
        BOOL tableExist = NO;
        
        if ([ModeGraphORConsol isEqualToString:graphicsTableMode] || [ModeGraphORConsol isEqualToString:consoleTableMode]) // Dentro de la tabla
        {
            tableExist = NO;
            for (int i = 0; i < [arrayTables count]; i++) {
                
                if ([[arrayTables objectAtIndex:i] isEqualToString:[queryDictionary objectForKey:@"tableName"]]) { tableExist = YES; break;}
            }
            
            if (tableExist == YES) {
                
            // UsingCurrentData permite realizar la sigte consulta, a partir de los datos resultantes (usado en consultas avanzadas usando el asistente)
            [self makeConsulteInTable:[queryDictionary objectForKey:@"tableName"] Ofdatabase:tempDBname Fields:[queryDictionary objectForKey:@"fields"] FieldCondition:[queryDictionary objectForKey:@"conditionalField"] CondOperator:[queryDictionary objectForKey:@"condOperator"] ConditionValue:[queryDictionary objectForKey:@"condValue"] ThenPlaceItinView:viewTableContainer WithFrame:CGRectMake(200, 250, 624, 388) UsingCurrentData:NO Animation:YES]; // 0, 180, 1024, 588
            }
            else
            { [self createAlertWithTitle:@"Not match" Message:[NSString stringWithFormat:@"The table \"%@\" does not exist in the current data base.",[queryDictionary objectForKey:@"tableName"]] CancelBtnTitle:@"Accept" OtherBtnTitle:nil]; }
        }
        else if ([ModeGraphORConsol isEqualToString:externConsultTableMode]) // Fuera de la tabla
        {
            BOOL databaseExist = NO;
            
                arrayDataBase = [self getDataBaseNamesFromRootpath:oneDataDirPath];  // Cargando el array con el nombre de las base de datos en el dispositivo
            
                for (int i = 0; i < [arrayDataBase count]; i++) {
                
                    if ([[arrayDataBase objectAtIndex:i] isEqualToString:useDatabaseTxt.text]) { databaseExist = YES; break; }
                }
            
            if (databaseExist == YES) {
                
                    tempDBname = useDatabaseTxt.text;
                
                    arrayTables = [self getTableNamesFromDataBaseName:useDatabaseTxt.text RootPath:oneDataDirPath];   // Cargando el array con las tablas de la DB
                
                    tempTBname = [queryDictionary objectForKey:@"tableName"];
                
                    tableExist = NO;
                    for (int i = 0; i < [arrayTables count]; i++) {
                    
                        if ([tempTBname isEqualToString:[arrayTables objectAtIndex:i]]) { tableExist = YES; break;} // Verifica si existe la base de datos.
                    }
                
            if (tableExist == YES) {
                
                BOOL useCurrentData = NO;
                
                if ([consultType isEqualToString:@"SIMPLE"]) { useCurrentData = NO; }
                else if ([consultType isEqualToString:@"ADVANCED"]){useCurrentData = YES;}
            
            if ([[self lookForTableKeyAtDBPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,tempDBname] WithTableName:tempTBname Funtion:@"GET" ForCasePOSTSetTheReferenceQuestion:nil Password:nil] count] == 0) {  // Busca en la carpeta de contrasenas de la base de datos, Si no se encontro ningun archivo (nombretabla.pass) el tamano del array sera 0 indicando que la tabla no posee contrasena.
                
                // UsingCurrentData permite realizar la sigte consulta, a partir de los datos resultantes (usado en consultas avanzadas usando el asistente)
                [self makeConsulteInTable:[queryDictionary objectForKey:@"tableName"] Ofdatabase:tempDBname Fields:[queryDictionary objectForKey:@"fields"] FieldCondition:[queryDictionary objectForKey:@"conditionalField"] CondOperator:[queryDictionary objectForKey:@"condOperator"] ConditionValue:[queryDictionary objectForKey:@"condValue"] ThenPlaceItinView:externConsultView WithFrame:CGRectMake(0, externConsultView.frame.size.height - 350, externConsultView.frame.size.width, 350) UsingCurrentData:useCurrentData Animation:YES];
            }
            else  // El tamano del array es mayor que 0. (indica que la tabla posee contrasena)
            {
                if ([consultType isEqualToString:@"SIMPLE"]) {
                
                    [self passwordAlert];
                }
                else if ([consultType isEqualToString:@"ADVANCED"])
                {
                    [self createAlertWithTitle:@"The task can not be processed" Message:@"The table has password, unlock it and try again." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
                }
            }}
            else if (tableExist == NO) {[self createAlertWithTitle:@"Not match" Message:[NSString stringWithFormat:@"The table \"%@\" does not exist in the current data base.",[queryDictionary objectForKey:@"tableName"]] CancelBtnTitle:@"Accept" OtherBtnTitle:nil]; errorAssistantConsult = YES;}
            }
            else if (databaseExist == NO)
            {
                errorAssistantConsult = YES;
                [self createAlertWithTitle:@"Not match" Message:@"The database specified does not exist." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
            }
        }
    }}
# pragma INSERTA DATOS EN LA TABLA (INSERT INTO)
    else if ([[queryDictionary objectForKey:@"sentence"] isEqualToString:@"insertinto"]) // solo realiza inserciones en modo externo, las inserciones en modo grafico (con tablas) se pueden realizar de manera manual
    {
        if ([ModeGraphORConsol isEqualToString:externConsultTableMode]) {
            
            BOOL tableExist = NO;
            BOOL databaseExist = NO;
            
            arrayDataBase = [self getDataBaseNamesFromRootpath:oneDataDirPath];  // Cargando el array con el nombre de las base de datos en el dispositivo
            
            for (int i = 0; i < [arrayDataBase count]; i++) {
                
                if ([[arrayDataBase objectAtIndex:i] isEqualToString:useDatabaseTxt.text]) { databaseExist = YES; break; }
            }
            
            if (databaseExist == YES) {
                
                tempDBname = useDatabaseTxt.text;
                
                arrayTables = [self getTableNamesFromDataBaseName:useDatabaseTxt.text RootPath:oneDataDirPath];   // Cargando el array con las tablas de la DB
                
                tempTBname = [queryDictionary objectForKey:@"tableName"];
                
                tableExist = NO;
                for (int i = 0; i < [arrayTables count]; i++) {
                    
                    if ([tempTBname isEqualToString:[arrayTables objectAtIndex:i]]) { tableExist = YES; } // Verifica si existe la base de datos.
                }
                
                if (tableExist == YES) {
                    
                    if ([[self lookForTableKeyAtDBPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,tempDBname] WithTableName:tempTBname Funtion:@"GET" ForCasePOSTSetTheReferenceQuestion:nil Password:nil] count] == 0) {  // Busca en la carpeta de contrasenas de la base de datos, Si no se encontro ningun archivo (nombretabla.pass) el tamano del array sera 0 indicando que la tabla no posee contrasena.
                        
                        // inserta los valores en la tabla que estan descriptos en el query. (en caso de usar el asistente, el mismo se encargara de generar un query para su inserccion)
                        [self insertIntoTable:[queryDictionary objectForKey:@"tableName"] InFields:[queryDictionary objectForKey:@"fields"] Values:[queryDictionary objectForKey:@"values"] Database:tempDBname];
                    }
                    else  // El tamano del array es mayor que 0. (indica que la tabla posee contrasena)
                    {
                        [self passwordAlert];
                    }}
                else if (tableExist == NO) {[self createAlertWithTitle:@"Not match" Message:[NSString stringWithFormat:@"The table \"%@\" does not exist in the current data base.",[queryDictionary objectForKey:@"tableName"]] CancelBtnTitle:@"Accept" OtherBtnTitle:nil];}
            }
            else if (databaseExist == NO)
            {
                [self createAlertWithTitle:@"Not match" Message:@"The database specified does not exist." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
            }
        }
        else if (![ModeGraphORConsol isEqualToString:externConsultTableMode])
        {
            [self createAlertWithTitle:@"Not match" Message:@"Insertions are just allowed in exterm consults." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
    
}
    
# pragma BORRAR DATOS DE LA TABLA (DELETE)
    else if ([[queryDictionary objectForKey:@"sentence"] isEqualToString:@"delete"])
    {
        BOOL tableExist = NO;
        
        if ([ModeGraphORConsol isEqualToString:graphicsTableMode] || [ModeGraphORConsol isEqualToString:consoleTableMode]) // Dentro de la tabla
        {
            tableExist = NO;
            for (int i = 0; i < [arrayTables count]; i++) {
                
                if ([[arrayTables objectAtIndex:i] isEqualToString:[queryDictionary objectForKey:@"tableName"]]) { tableExist = YES; break;}
            }
            
            if (tableExist == YES) {
                
                [self deleteFromTable:[queryDictionary objectForKey:@"tableName"] ConditionalField:[queryDictionary objectForKey:@"conditionalField"] ConditionalOperator:[queryDictionary objectForKey:@"condOperator"] ConditionalValue:[queryDictionary objectForKey:@"condValue"]];
            }
            else
            { [self createAlertWithTitle:@"Not match" Message:[NSString stringWithFormat:@"The table \"%@\" does not exist in the current data base.",[queryDictionary objectForKey:@"tableName"]] CancelBtnTitle:@"Accept" OtherBtnTitle:nil]; }
        }
        else if ([ModeGraphORConsol isEqualToString:externConsultTableMode]) // Fuera de la tabla
        {
            BOOL databaseExist = NO;
            arrayDataBase = [self getDataBaseNamesFromRootpath:oneDataDirPath];  // Cargando el array con el nombre de las base de datos en el dispositivo
            
            for (int i = 0; i < [arrayDataBase count]; i++) {
                
                if ([[arrayDataBase objectAtIndex:i] isEqualToString:useDatabaseTxt.text]) { databaseExist = YES; break; }
            }
            
            if (databaseExist == YES) {
            
                tempDBname = useDatabaseTxt.text;
            
                arrayTables = [self getTableNamesFromDataBaseName:useDatabaseTxt.text RootPath:oneDataDirPath];   // Cargando el array con las tablas de la DB
                tempTBname = [queryDictionary objectForKey:@"tableName"];
            
                tableExist = NO;
                for (int i = 0; i < [arrayTables count]; i++) {
                 
                    if ([tempTBname isEqualToString:[arrayTables objectAtIndex:i]]) { tableExist = YES; } // Verifica si existe la base de datos.
                }
            
                if (tableExist == YES) {
                
                    if ([[self lookForTableKeyAtDBPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,tempDBname] WithTableName:tempTBname Funtion:@"GET" ForCasePOSTSetTheReferenceQuestion:nil Password:nil] count] == 0) {  // Busca en la carpeta de contrasenas de la base de datos, Si no se encontro ningun archivo (nombretabla.pass) el tamano del array sera 0 indicando que la tabla no posee contrasena.
                
                        [self deleteFromTable:[queryDictionary objectForKey:@"tableName"] ConditionalField:[queryDictionary objectForKey:@"conditionalField"] ConditionalOperator:[queryDictionary objectForKey:@"condOperator"] ConditionalValue:[queryDictionary objectForKey:@"condValue"]];
                    }
                    else  // El tamano del array es mayor que 0. (indica que la tabla posee contrasena)
                    {
                        [self passwordAlert];
                    }}
                    else if (tableExist == NO) {[self createAlertWithTitle:@"Not match" Message:[NSString stringWithFormat:@"The table \"%@\" does not exist in the current data base.",[queryDictionary objectForKey:@"tableName"]] CancelBtnTitle:@"Accept" OtherBtnTitle:nil];}
            
            }
            else if (databaseExist == NO)
            {
                [self createAlertWithTitle:@"Not match" Message:@"The database specified does not exist." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
            }
        }
    }
# pragma BORRAR TABLA (DROP)
    else if ([[queryDictionary objectForKey:@"sentence"] isEqualToString:@"drop"])
    {
        BOOL exist = NO;
        
        if ([ModeGraphORConsol isEqualToString:graphicsTableMode] || [ModeGraphORConsol isEqualToString:consoleTableMode]) {
            
            // BASE DE DATOS ACTUAL: TempDBname
            // TABLA ACTUAL: TempTBname
            
            if ([[queryDictionary objectForKey:@"object"] isEqualToString:@"database"]) { // Borrara una base de datos
                
                for (int i = 0; i < [arrayDataBase count]; i++) {
                    
                    if ([[arrayDataBase objectAtIndex:i] isEqualToString:[queryDictionary objectForKey:@"objectName"]]) { exist = YES; break; }
                }
                
                if (exist == YES) { // Existe la base de datos
                    
                    if ([self dropOBJECT:[queryDictionary objectForKey:@"objectName"] KindOfObject:[queryDictionary objectForKey:@"object"] UseDataBase:tempDBname ArrayDataBase:arrayDataBase Arraytables:nil RootPath:oneDataDirPath] == YES)  // Borra la base de datos. Si es la actual vuelve a la pantalla de inicio (data base)
                    {
                        if ([tempDBname isEqualToString:[queryDictionary objectForKey:@"objectName"]]) { // Borrando la base de datos actual
                        
                            [self deallocObjects];
                        }
                    }
                    else
                    {
                        [self createAlertWithTitle:@"Not match" Message:@"The database specified does not exist." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
                    }
                }
                else if (exist == NO)
                {
                    [self createAlertWithTitle:@"Not match" Message:@"The database specified does not exist." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
                }
            }
            else if ([[queryDictionary objectForKey:@"object"] isEqualToString:@"table"])  // Borrara una tabla
            {
                for (int i = 0; i < [arrayTables count]; i++) {
                    
                     if ([[arrayTables objectAtIndex:i] isEqualToString:[queryDictionary objectForKey:@"objectName"]]) { exist = YES; break; }
                }
                if (exist == YES) { // Existe la tabla
                    
                    if ([self dropOBJECT:[queryDictionary objectForKey:@"objectName"] KindOfObject:[queryDictionary objectForKey:@"object"] UseDataBase:tempDBname ArrayDataBase:nil Arraytables:arrayTables RootPath:oneDataDirPath] == YES)  // Borra la tabla. Si es la actual vuelve a la pantalla de inicio (data base)
                    {
                        if ([tempTBname isEqualToString:[queryDictionary objectForKey:@"objectName"]]) { // Borrando la tabla actual
                            
                            [self deallocObjects];
                        }
                    }
                    else
                    {
                        [self createAlertWithTitle:@"Not match" Message:@"The table specified does not exist." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
                    }
                }
                else if (exist == NO)
                {
                    [self createAlertWithTitle:@"Not match" Message:@"The table specified does not exist." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
                }
            }
        }
        else if ([ModeGraphORConsol isEqualToString:externConsultTableMode])
        {
            arrayTables = [self getTableNamesFromDataBaseName:useDatabaseTxt.text RootPath:oneDataDirPath];   // Cargando el array con las tablas de la DB
            arrayDataBase = [self getDataBaseNamesFromRootpath:oneDataDirPath];  // Cargando el array con el nombre de las base de datos en el dispositivo
            
            if ([[queryDictionary objectForKey:@"object"] isEqualToString:@"database"]) { // Borrara una base de datos
                
                tempDBname = [queryDictionary objectForKey:@"objectName"];  // Nombre de la base de datos especificada en el query
                
                for (int i = 0; i < [arrayDataBase count]; i++) { // Verifica si existe la base de datos.
                    
                    if ([tempDBname isEqualToString:[arrayDataBase objectAtIndex:i]]) { exist = YES; break; }
                }
                
                if (exist == YES) { // La base de datos existe
                    
                    [self dropOBJECT:tempDBname KindOfObject:[queryDictionary objectForKey:@"object"] UseDataBase:nil ArrayDataBase:arrayDataBase  Arraytables:arrayTables RootPath:oneDataDirPath]; // Borra la base de datos, actualiza el array de base de datos y elimina el scroll db
                    useDatabaseTxt.text = @"";
                }
                else if (exist == NO)
                {
                    [self createAlertWithTitle:@"Not match" Message:@"The database specified does not exist." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
                }
                
            }
            else if ([[queryDictionary objectForKey:@"object"] isEqualToString:@"table"])
            {
                tempTBname = [queryDictionary objectForKey:@"objectName"];
                tempDBname = useDatabaseTxt.text;
                
                for (int i = 0; i < [arrayDataBase count]; i++) {
                    
                    if ([tempDBname isEqualToString:[arrayDataBase objectAtIndex:i]]) { exist = YES; break; }
                }
                
                if (exist == YES) { // Existe la base de datos
                    
                    exist = NO;
                    for(int i = 0; i < [arrayTables count]; i++) {
                        
                        if ([tempTBname isEqualToString:[arrayTables objectAtIndex:i]]) { exist = YES; break; }
                    }
                }
                else // No existe la base de datos
                {
                    [self createAlertWithTitle:@"Not match" Message:@"The database specified does not exist." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
                }
                
                if (exist == YES) { // Existen la base de datos y la tabla
                    
                    [self dropOBJECT:tempTBname KindOfObject:[queryDictionary objectForKey:@"object"] UseDataBase:tempDBname ArrayDataBase:nil Arraytables:arrayTables RootPath:oneDataDirPath];
                }
                else // No existe la base de datos o la tabla
                {
                    [self createAlertWithTitle:@"Not match" Message:@"The table specified does not exist." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
                }}}
    }
# pragma ACTUALIZA LOS DATOS DE LA TABLA (UPDATE)
    else if ([[queryDictionary objectForKey:@"sentence"] isEqualToString:@"update"])
    {
        BOOL exist = NO;
        
        NSString *table = [queryDictionary objectForKey:@"tableName"];
        NSString *singleField = [queryDictionary objectForKey:@"singleField"];
        NSString *singleOperator = [queryDictionary objectForKey:@"singleFieldOperator"];
        NSString *singleValue = [queryDictionary objectForKey:@"singleFieldValue"];
        NSString *condField = [queryDictionary objectForKey:@"conditionalField"];
        NSString *condOperator = [queryDictionary objectForKey:@"condOperator"];
        NSString *condValue = [queryDictionary objectForKey:@"condValue"];
        
        
        if ([ModeGraphORConsol isEqualToString:graphicsTableMode] || [ModeGraphORConsol isEqualToString:consoleTableMode]) {
            
            // Database, Tablename: actual
            
            for (int i = 0; i < [arrayTables count]; i++) {  // Verifica que la tabla exista en la base de datos.
                
                if ([table isEqualToString:[arrayTables objectAtIndex:i]]) { exist = YES; }
            }
            
            if (exist == YES) { // Existe la tabla
                
                [self updateTable:table SETSingleField:singleField SingleOperator:singleOperator SingleValue:singleValue WHEREConditionalField:condField ConditionalOperator:condOperator ConditionalValue:condValue];
                
            }
            else if (exist == NO)
            {
                [self createAlertWithTitle:@"Not match" Message:[NSString stringWithFormat:@"The table \"%@\" does not exist in the current data base.",table] CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
            }
        }
        else if ([ModeGraphORConsol isEqualToString:externConsultTableMode])
        {
            // Database: useDatabaseTxt, Table: specified.
            
            arrayTables = [self getTableNamesFromDataBaseName:useDatabaseTxt.text RootPath:oneDataDirPath];   // Cargando el array con las tablas de la DB
            arrayDataBase = [self getDataBaseNamesFromRootpath:oneDataDirPath];  // Cargando el array con el nombre de las base de datos en el dispositivo
            
            tempDBname = useDatabaseTxt.text;
            tempTBname = table;
            
            for (int i = 0; i < [arrayDataBase count]; i++) { // Verifica que la base de datos exista
                
                if ([tempDBname isEqualToString:[arrayDataBase objectAtIndex:i]]) { exist = YES; break;}
            }
            
            if (exist == YES) { // Existe la base de datos?
                exist = NO;
                for (int i = 0; i < [arrayTables count]; i++) {  // Verifica que la tabla exista en la base de datos.
                    
                    if ([tempTBname isEqualToString:[arrayTables objectAtIndex:i]]) { exist = YES; break;}
                }
            }
            else if (exist == NO)
            {
                [self createAlertWithTitle:@"Not match" Message:@"The database specified does not exist." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
            }
            if (exist == YES) { // Existe la tabla
                
                if ([[self lookForTableKeyAtDBPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,tempDBname] WithTableName:tempTBname Funtion:@"GET" ForCasePOSTSetTheReferenceQuestion:nil Password:nil] count] == 0) {  // Busca en la carpeta de contrasenas de la base de datos, Si no se encontro ningun archivo (nombretabla.pass) el tamano del array sera 0 indicando que la tabla no posee contrasena.
                    
                    [self updateTable:table SETSingleField:singleField SingleOperator:singleOperator SingleValue:singleValue WHEREConditionalField:condField ConditionalOperator:condOperator ConditionalValue:condValue];
                }
                else  // El tamano del array es mayor que 0. (indica que la tabla posee contrasena)
                {
                    [self passwordAlert];
                }
            }
            else if (exist == NO)
            {
                [self createAlertWithTitle:@"Not match" Message:[NSString stringWithFormat:@"The table \"%@\" does not exist in the current data base.",table] CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
            }
        }
    }
    
}
#pragma PROCESA LAS CONSULTAS AVANZADAS
-(NSMutableArray *)selectInSelections:(NSMutableArray *)queries database:(NSString *)database
{
    NSMutableArray * result = [[NSMutableArray alloc] initWithCapacity:0];
    NSString * fieldsIntegration = @"";
    NSString * errorMessage = @"";
    
    [result addObject:[[queries objectAtIndex:[queries count] - 1] objectForKey:@"condValue"]];
    
    [useDatabaseTxt setText:@"apple"];
    NSLog(@"LOG***** %@ ",queries);
    
    for (int i  = (int)[queries count] - 1; i >= 0 ; i--) { // Procesando todas las consultas en orden n --> 1.
        
        // Procesar solo un campo de los subqueries, el resultado es el valor condicional de la siguiente consulta. Orden final - comienzo del query.
        if ((i > 0) && (([[[queries objectAtIndex:i] objectForKey:@"fields"] count] > 1) || [[[[queries objectAtIndex:i] objectForKey:@"fields"] objectAtIndex:0] isEqualToString:@"*"])) errorMessage = @"Query incorrect: you just can specified one field in all subconsults.";
        
        if ([[[queries objectAtIndex:i] objectForKey:@"fields"] count] == 0) errorMessage = @"Query incorrect: you must specified at least one field";
        
        
        if (errorMessage.length == 0) {
       
            // Recopilando los datos de las tablas
            [self allocTableWithDataBaseName:database AtPath:[NSString stringWithFormat:@"%@/%@/%@",oneDataDirPath,database,[[queries objectAtIndex:i] objectForKey:@"tableName"]] FUNTION:@"NONE" MODE:ModeGraphORConsol];  // Cargando los datos de la tabla.

            /*
             * ArrayDataField: Contiene los datos de la tabla
             * ArrayFieldNames: Contiene el nombre de los campos
            */
            
            fieldsIntegration = @"";
        
            for (int f = 0; f < [[[queries objectAtIndex:i] objectForKey:@"fields"] count]; f++) { // Agrupa los campos especificados
                
                fieldsIntegration = [fieldsIntegration stringByAppendingString:[NSString stringWithFormat:@"%@",[[[queries objectAtIndex:i] objectForKey:@"fields"] objectAtIndex:f]]];
                if ((f + 1) < [[[queries objectAtIndex:i] objectForKey:@"fields"] count]) fieldsIntegration = [fieldsIntegration stringByAppendingString:@","];
            }
        
            
            for (int i = 0; i < [result count]; i++) { // Procesa la consulta en (i) para cada valor almacenado. El resultado es almacenado en ArrayDataField
           
                if (![[[[queries objectAtIndex:i] objectForKey:@"condOperator"] lowercaseString] isEqualToString:@"in"]) { // Operador: <, > o =
               
                    [self consultAction:[NSString stringWithFormat:@"select %@ from %@ where %@ %@ %@",fieldsIntegration,[[queries objectAtIndex:i] objectForKey:@"tableName"],[[queries objectAtIndex:i] objectForKey:@"conditionalField"],[[queries objectAtIndex:i] objectForKey:@"condOperator"],[result objectAtIndex:i]] ConsultType:@"ADVANCED"];
            
                    NSLog(@"--***** %@ \n-- %@",arrayDataField,[NSString stringWithFormat:@"select %@ from %@ where %@ %@ %@",fieldsIntegration,[[queries objectAtIndex:i] objectForKey:@"tableName"],[[queries objectAtIndex:i] objectForKey:@"conditionalField"],[[queries objectAtIndex:i] objectForKey:@"condOperator"],[result objectAtIndex:i]]);
                }
                else if ([[[[queries objectAtIndex:i] objectForKey:@"condOperator"] lowercaseString] isEqualToString:@"in"]) // Operador: in
                {
                    [self consultAction:[NSString stringWithFormat:@"select %@ from %@ where %@ = %@",fieldsIntegration,[[queries objectAtIndex:i] objectForKey:@"tableName"],[[queries objectAtIndex:i] objectForKey:@"conditionalField"],[result objectAtIndex:i]] ConsultType:@"ADVANCED"];
                    
                    NSLog(@"++***** %@ \n-- %@",arrayDataField,[NSString stringWithFormat:@"select %@ from %@ where %@ = %@",fieldsIntegration,[[queries objectAtIndex:i] objectForKey:@"tableName"],[[queries objectAtIndex:i] objectForKey:@"conditionalField"],[result objectAtIndex:i]]);
                }
                
                for (int a = 0; i < [arrayDataField count]; a++) {
                    
                    [result addObject:[arrayDataField objectAtIndex:a]]; // Agrupa los datos resultantes de las consultas 
                }
                NSLog(@"**RESULT** %@ ",result);

            }
            
          //  [result addObject:arrayDataField];
            //NSLog(@"*¡¡¡%@ ",result);
            
        }
        else {[self createAlertWithTitle:@"Not match" Message:errorMessage CancelBtnTitle:@"Accept" OtherBtnTitle:nil];}
    }
    
    
    
    return result;
}

#pragma CREA LA TABLA EN MODO CONSOLA (SOLO LECTURA)
-(void)createConsoleTableViewAtFrame:(CGRect )rect InView:(UIView *)inView ArrayDataField:(NSMutableArray *)arrayData ArrayFieldNames:(NSMutableArray *)arrayFieldName txtViewWidth:(NSInteger )width Alpha:(NSInteger )alpha ThenSetInformationIfisNeeded:(NSString *)info
{
    tableConsoleView = [[UIView alloc] initWithFrame:rect]; NSLog(@"====)))A)))SD)()ASD ");
    [tableConsoleView setBackgroundColor:excelTableViewBGColor];
    tableConsoleView.layer.borderWidth = 0.3;
    tableConsoleView.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    tableConsoleView.layer.cornerRadius = 3;
    [tableConsoleView setAlpha:alpha];
    [inView addSubview:tableConsoleView];
    
    UIScrollView * fieldScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(40, 40, rect.size.width - 80, rect.size.height - 70)];
    fieldScroll.delegate = self;
    [fieldScroll setScrollEnabled:YES];
    [fieldScroll setShowsHorizontalScrollIndicator:NO];
    [fieldScroll setShowsVerticalScrollIndicator:NO];
    fieldScroll.layer.borderWidth = 0.3;
    fieldScroll.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.3].CGColor;
    fieldScroll.layer.cornerRadius = 3;
    [fieldScroll setBackgroundColor:[UIColor whiteColor]];
    [fieldScroll setTag:1];
    [tableConsoleView addSubview:fieldScroll];
    
    UIScrollView *xScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(40, 0, rect.size.width - 80, 40)];
    [xScroll setContentSize:CGSizeMake((width * [arrayFieldName  count]), 0)];
    [xScroll setScrollEnabled:NO];
    [tableConsoleView addSubview:xScroll];
    
    consoleFieldName = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, xScroll.frame.size.height)];
    [consoleFieldName setBackgroundColor:[UIColor clearColor]];
    [xScroll addSubview:consoleFieldName];
    
    UIScrollView *yScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, 40, fieldScroll.frame.size.height)];
    [yScroll setContentSize:CGSizeMake(0, 0)];
    [yScroll setScrollEnabled:NO];
    [tableConsoleView addSubview:yScroll];
    
    lineNumber = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 40, yScroll.frame.size.height)];
    [lineNumber setTextAlignment:NSTextAlignmentCenter];
    [lineNumber setFont:[UIFont fontWithName:@"Heiti TC" size:13]];
    [lineNumber setBackgroundColor:excelTableViewBGColor];
    [lineNumber setTextColor:normalStateTableInternalBtnColor];
    [yScroll addSubview:lineNumber];
    
    if ([ModeGraphORConsol isEqualToString:graphicsTableMode] || [ModeGraphORConsol isEqualToString:externConsultTableMode]) {
   
        if (![ModeGraphORConsol isEqualToString:externConsultTableMode]) {
        
            UIButton *closeConsole = [[UIButton alloc] initWithFrame:CGRectMake(rect.size.width - 100, rect.size.height - 30, 50, 30)];
            [closeConsole setTitle:@"CLOSE" forState:UIControlStateNormal];
            [closeConsole setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
            [[closeConsole titleLabel] setFont:[UIFont fontWithName:@"Heiti tc" size:11]];
            [closeConsole setTag:17];
            [closeConsole addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
            [tableConsoleView addSubview:closeConsole];
        }
    
        if ([info length] == 0) {
         
            UIView *between = [[UIView alloc] init];
            if ([ModeGraphORConsol isEqualToString:externConsultTableMode]) { [between setFrame:CGRectMake(rect.size.width - 135, rect.size.height - 25, 1, 20)]; } else { [between setFrame:CGRectMake(rect.size.width - 125, rect.size.height - 25, 1, 20)]; }
            between.layer.cornerRadius = 2;
            between.layer.borderWidth = 0.3;
            between.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
            [tableConsoleView addSubview:between];
            
        }
    
        UIButton *saveConsoleResult = [[UIButton alloc] init];
        if ([ModeGraphORConsol isEqualToString:graphicsTableMode]) { [saveConsoleResult setFrame:CGRectMake(rect.size.width - 230, rect.size.height - 30, 80, 30)]; } else if ([ModeGraphORConsol isEqualToString:externConsultTableMode]) { [saveConsoleResult setFrame:CGRectMake(rect.size.width - 130, rect.size.height - 30, 80, 30)]; }
        
        if ([info length] == 0) {
            
            [saveConsoleResult setTitle:@"SAVE RESULT" forState:UIControlStateNormal];
            [saveConsoleResult setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
            [[saveConsoleResult titleLabel] setFont:[UIFont fontWithName:@"Heiti tc" size:11]];
            [saveConsoleResult setTag:20];
            [saveConsoleResult addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
            [tableConsoleView addSubview:saveConsoleResult];
        }
    
        if ([ModeGraphORConsol isEqualToString:externConsultTableMode]) {
            
            UILabel *Info = [[UILabel alloc] initWithFrame:CGRectMake(40, rect.size.height - 30, rect.size.width - 80, 30)];
            [Info setText:info];
            [Info setTextAlignment:NSTextAlignmentLeft];
            [Info setFont:[UIFont fontWithName:@"Heiti TC" size:11]];
            [Info setTextColor:normalStateTableInternalBtnColor];
            [tableConsoleView addSubview:Info];
        }
        
        if (![ModeGraphORConsol isEqualToString:externConsultTableMode]) {
        
            UIImageView *moveImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
            [moveImage setImage:[UIImage imageNamed:@"move.png"]];
            [tableConsoleView addSubview:moveImage];
        }
        
        arraydataQueryResult = [arrayData mutableCopy];  // Contiene los resultados de la consulta listo para guardarlos
        arrayFieldNameQueryResult = [arrayFieldName mutableCopy]; // Contiene los nombres de los campos resultados de la consulta
    }
    
    for (int i = 0; i < ([arrayData count] / [arrayFieldName count]); i++) {  // Numero de lineas
        
        [lineNumber setText:[lineNumber.text stringByAppendingString:[NSString stringWithFormat:@"%i",(i + 1)]]];
        
        if (i != (([arrayData count] / [arrayFieldName count]) - 1)) { [lineNumber setText:[lineNumber.text stringByAppendingString:[NSString stringWithFormat:@"\n\n"]]]; } else { [yScroll setContentSize:CGSizeMake(0, lineNumber.frame.size.height)]; [lineNumber sizeToFit]; }
    }
    
    NSString *data = @"";
    NSString *substring = @"";
    for (int i = 0; i < [arrayFieldName count]; i++) {  // Nombre de los campos
        
        UILabel * field = [[UILabel alloc] initWithFrame:CGRectMake((i * width), 0, width, xScroll.frame.size.height)];
        [field setText:[NSString stringWithFormat:@"%@",[arrayFieldName objectAtIndex:i]]];
        [field setTextAlignment:NSTextAlignmentCenter];
        [field setFont:[UIFont fontWithName:@"Heiti TC" size:15]];
        [field setTextColor:normalStateTableInternalBtnColor];
        [consoleFieldName addSubview:field];
        
        // extremos
        UIView *between1 = [[UIView alloc] initWithFrame:CGRectMake((i * width), 20, 1, 20)];
        between1.layer.cornerRadius = 2;
        between1.layer.borderWidth = 0.3;
        between1.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.1].CGColor;
        [consoleFieldName addSubview:between1];
        UIView *between2 = [[UIView alloc] initWithFrame:CGRectMake((i * width) + width, 20, 1, 20)];
        between2.layer.cornerRadius = 2;
        between2.layer.borderWidth = 0.3;
        between2.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.1].CGColor;
        [consoleFieldName addSubview:between2];
        
        for (int a = 0; a < [arrayData count]; a++) { // Datos
            
            if (((a * [arrayFieldName count]) + i) < [arrayData count]) {
                
                if ([[arrayData objectAtIndex:((a * [arrayFieldName count]) + i)] length] > 12) { substring = [NSString stringWithFormat:@"%@-",[[arrayData objectAtIndex:((a *[arrayFieldName count]) + i)] substringToIndex:11]]; } else { substring = [arrayData objectAtIndex:((a * [arrayFieldName count]) + i)]; }
                
                data = [data stringByAppendingString:[NSString stringWithFormat:@"%@\n\n",substring]];
            }
            else {break;}
        }
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake((i * width), 0, width, lineNumber.frame.size.height)];
        [textView setEditable:NO];
        [textView setScrollEnabled:NO];
        [textView setTextAlignment:NSTextAlignmentCenter];
        [textView setFont:[UIFont fontWithName:@"Heiti TC" size:13]];
        textView.layer.borderWidth = 0.3;
        textView.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
        [textView setBackgroundColor:[UIColor whiteColor]];
        [textView setTag:i];
        [textView setText:data];
        [fieldScroll addSubview:textView];
        
        [fieldScroll setContentSize:CGSizeMake(((i + 1) * width), lineNumber.frame.size.height)];
        data = @"";
    }
    
    [arrayData removeAllObjects];
    [arrayFieldName removeAllObjects];
}

#pragma CREA LA TABLA DE ENTRADA DE DATOS CON EL NOMBRE DE CADA COLUMNA
-(void) createExcelTableWithName:(NSString *)tableName ColFieldNames:(NSMutableArray *)colFieldName PlaceIn:(CGRect )rect InView:(UIView *)view Alpha:(NSInteger)alpha ThenCreateNumFieldsInX:(NSInteger )numFieldsX FieldsInY:(NSInteger)numFieldsY WithWidth:(NSInteger)Width AndHeight:(NSInteger )Height SpaceSize:(NSInteger)spaceSize AndKeyBoardType:(NSMutableArray *)keyBoardType willCREATEorUPDATE:(NSString *)Funtion modeINPUTorOUTPUT:(NSString *)mode
{
    if ([Funtion isEqualToString:@"CREATE"]) {   // Si esta cargando o creando la tabla, create el marco donde estara el scroll con los datos. Si esta Actualizando la tabla, solo creara el scroll con sus datos
    
    viewTableContainer = [[UIView alloc] initWithFrame:CGRectMake(1024, 0, 1024, 768)];
    [viewTableContainer setBackgroundColor:[UIColor whiteColor]];
    [viewTableContainer setAlpha:alpha];
    [view addSubview:viewTableContainer];
    
    // Vista de funciones
    
    [self createTableObjetcs];
    }
    
    // OBJETOS PRINCIPALES: SE CREAN UTILIZANDO AMBOS METODOS (CREATE o UPDATE)
    
    excelTableView = [[UIView alloc] initWithFrame:rect];
    [excelTableView setBackgroundColor:excelTableViewBGColor];
    excelTableView.layer.borderWidth = 0.3;
    excelTableView.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    [viewTableContainer addSubview:excelTableView];
    
    if ([mode isEqualToString:graphicsTableMode]) {
    
    tablePassStatusImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    
    if ([[self lookForTableKeyAtDBPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,tempDBname] WithTableName:tempTBname Funtion:@"GET" ForCasePOSTSetTheReferenceQuestion:nil Password:nil] count] == 0) {  // La tabla no posee contrasena.
        
        [tablePassStatusImg setImage:[UIImage imageNamed:@"tableUnlocked.png"]];
    }
    else
    {
        [tablePassStatusImg setImage:[UIImage imageNamed:@"tableLocked.png"]];
    }
    [excelTableView addSubview:tablePassStatusImg];
    
    
    UIScrollView *xScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 0, excelTableView.frame.size.width - 80, 50)];
    [xScroll setContentSize:CGSizeMake((Width + spaceSize) * numFieldsX, 0)];
    [xScroll setScrollEnabled:NO];
    [excelTableView addSubview:xScroll];
    
    UIScrollView *yScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, 50, excelTableView.frame.size.height - 80)];
    [yScroll setContentSize:CGSizeMake(0, (Height + spaceSize) * numFieldsY)];
    [yScroll setScrollEnabled:NO];
    [excelTableView addSubview:yScroll];
    
    xViewExcelLabels = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (Width + spaceSize) * numFieldsX, 50)];
    [xViewExcelLabels setBackgroundColor:[UIColor clearColor]];
    [xScroll addSubview:xViewExcelLabels];
    
    yViewExcelLabels = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, (Height + spaceSize) * numFieldsY)];
    [yViewExcelLabels setBackgroundColor:[UIColor clearColor]];
    [yScroll addSubview:yViewExcelLabels];
    
    NSInteger X = 0;
    NSInteger Y = 0;
    NSInteger xColCount = 0;
    NSInteger yRowsCount = 0;
    
    [arrayOBfieldNames removeAllObjects];
    [arrayOBNumRows removeAllObjects];
    
    for (int xyId = 0; xyId < (numFieldsX + numFieldsY); xyId ++) {
        
        if (xColCount < [colFieldName count]) {
            
            X = (Width + spaceSize) * xColCount;
            
            UILabel *xlabel = [[UILabel alloc] initWithFrame:CGRectMake(X, 0, Width, /* Height */50)];
            [xlabel setText:[NSString stringWithFormat:@"%@",[arrayFieldNames objectAtIndex:xColCount]]];
            [xlabel setTextAlignment:NSTextAlignmentCenter];
            [xlabel setFont:HeitiTC_16];
            [xlabel setTextColor:normalStateTableInternalBtnColor];
            [xViewExcelLabels addSubview:xlabel];
            
            [arrayOBfieldNames addObject:xlabel]; // Guarda el objeto label de cada campo para indicar en que campo(fila) que se encuentra el dato buscado
            
        }
        if (yRowsCount < numFieldsY)
        {
            Y = (Height + spaceSize) * yRowsCount;
            
            UILabel *ylabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Y, 50, Height)];
            [ylabel setText:[NSString stringWithFormat:@"%i",(int)yRowsCount + 1]];
            [ylabel setTextAlignment:NSTextAlignmentCenter];
            [ylabel setTextColor:normalStateTableInternalBtnColor];
            [ylabel setFont:[UIFont fontWithName:@"Heiti TC" size:15]];
            [yViewExcelLabels addSubview:ylabel];
            
            [arrayOBNumRows addObject:ylabel]; // Guarda el objeto label de cada fila para indicar en que fila se encuentra el dato buscado
        }
        
        xColCount ++;
        yRowsCount ++;
    }
    
    fila = numFieldsY;
    
    [self createNumFieldsInX:numFieldsX FieldsInY:numFieldsY WithWidth:Width AndHeight:Height SpaceSize:spaceSize KeyBoardType:keyBoardType  PlaceIn:CGRectMake(50, 50, rect.size.width - 50, rect.size.height - 50) InView:excelTableView FUNTION:Funtion];
    
    [self createSheetButtonWithSheetPanelFrame:CGRectMake(50, excelTableView.frame.size.height - 35, excelTableView.frame.size.width - 80, 30) TableName:tempTBname DataBaseName:tempDBname RootPath:oneDataDirPath InView:excelTableView ORCreateSheetButtonWithNumOfSheetButtons:[arrayBtnSheet count] FUNTION:@"CREATE SHEET"]; // Funtion Create sheet: Crea el scroll que contendra los botones sheet y el boton principal. Funtion create sheet button: crea un boton (sheet)
    }
    else if ([mode isEqualToString:consoleTableMode])
    {
        [self processConsulteInTable:tempTBname Fields:[NSMutableArray arrayWithObject:@"*"] FieldCondition:nil CondOperator:nil ConditionValue:nil ATBarrayDataField:arrayDataField ArrayFieldName:colFieldName ArrayFieldCount:(numOfColField * [colFieldName count]) NumRows:numOfColField ThenPlaceItinView:viewTableContainer WithFrame:CGRectMake(0, 180, 1024, 588) Animation:NO Option_SetArrayDataFieldEqualToArrayResult:NO];
    }
}

#pragma CREA LOS CAMPOS DE ENTRADA DE DATOS
-(void) createNumFieldsInX:(NSInteger )numFieldsX FieldsInY:(NSInteger)numFieldsY WithWidth:(NSInteger)Width AndHeight:(NSInteger )Height SpaceSize:(NSInteger)spaceSize KeyBoardType:(NSMutableArray *)keyBoardType PlaceIn:(CGRect )rect InView:(UIView *)view FUNTION:(NSString *)funtion
{
   UIScrollView * fieldScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 45, rect.size.width - 30, rect.size.height - 30)];
    [fieldScroll setContentSize:CGSizeMake((Width + spaceSize) * numFieldsX, (Height + spaceSize) * numFieldsY)];
    fieldScroll.delegate = self;
    [fieldScroll setScrollEnabled:YES];
    [fieldScroll setShowsHorizontalScrollIndicator:NO];
    [fieldScroll setShowsVerticalScrollIndicator:NO];
    fieldScroll.layer.borderWidth = 0.3;
    fieldScroll.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.3].CGColor;
    [fieldScroll setBackgroundColor:[UIColor whiteColor]];
    [fieldScroll setTag:0];
    [view addSubview:fieldScroll];
    
    NSInteger X = 0;
    NSInteger Y = 0;
    NSInteger fieldTag = 0;
    NSInteger KeyBoardTypeCount = 0;
    
    for (int xfield = 0; xfield < numFieldsX; xfield++) {
        
        X = (Width + spaceSize) * xfield;
        
        for (int yfield = 0; yfield < numFieldsY; yfield++) {
            
            Y = (Height + spaceSize) * yfield;
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(X, Y, Width, Height)];
            textField.delegate = self;
            [textField setTag:fieldTag];
            [textField setTextAlignment:NSTextAlignmentCenter];
            [textField setFont:[UIFont fontWithName:@"Heiti TC" size:13]];
            textField.layer.borderWidth = 0.3;
            textField.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
           [textField setBackgroundColor:[UIColor whiteColor]];
            
            if ([[keyBoardType objectAtIndex:KeyBoardTypeCount] isEqualToString:@"Alphabetic"] || [[keyBoardType objectAtIndex:KeyBoardTypeCount] isEqualToString:@"PrimaryKeyA"]) {
                
                [textField setKeyboardType:UIKeyboardTypeDefault];
            }
            else if ([[keyBoardType objectAtIndex:KeyBoardTypeCount] isEqualToString:@"Numeric"] || [[keyBoardType objectAtIndex:KeyBoardTypeCount] isEqualToString:@"PrimaryKeyN"])
            {
                [textField setKeyboardType:UIKeyboardTypePhonePad];
            }
            
            [fieldScroll addSubview:textField];
            
            fieldTag ++;
            [arrayField addObject:textField];
            
            if ([arrayDataField count] == ([arrayField count] - 1)) {  // Si el array de datos es igual al array de campos -1; -1 porque antes (2 lineas atras) se le guardo un objeto (campo) indica que el array no contiene los datos cargados (esta nulo; nunca habia guardado los datos de los campos: ""), si no es igual al array de campos - 1; entonces contiene los datos cargados (datos o nulos).
 
                [arrayDataField addObject:@""];  // Crea un espacio utilizable en el array para cada textView
              //  [arrayDataSheet addObject:@""];  // Crea un espacio utilizable en el array para cada textView
            }
        }
        KeyBoardTypeCount ++;  // Incrementa el numero para buscar en esa posicion el tipo de teclado que el campo admitira. debe coincidir con la posicion del campo establecido.
    }
}

#define sheetBtnName @"Sheet"
# pragma CREA LOS BOTONES SHEET Y GESTIONA LAS HOJAS DE LA TABLA
-(void) createSheetButtonWithSheetPanelFrame:(CGRect )rect TableName:(NSString *)tableName DataBaseName:(NSString *)dataBaseName RootPath:(NSString *)rootPath InView:(UIView *)view ORCreateSheetButtonWithNumOfSheetButtons:(NSInteger ) numSheets FUNTION:(NSString *)funtion
{
    NSString *sheetTablePath = [NSString stringWithFormat:@"%@/%@/%@.%@",rootPath,dataBaseName,tableName,sheetBtnName];  // Ruta de la carpeta que contiene las hojas de la tabla. Las hojas se guardan en una carpeta en la misma ruta de la tabla (con PathExtention = .Sheet)
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:sheetTablePath]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:sheetTablePath withIntermediateDirectories:NO attributes:nil error:nil];  // Crea la carpeta con el nombre de la tabla.Sheet para guardar las hojas de la tabla.
    }
    
    NSInteger X = 100;
    NSInteger x = 100;
    UIButton *sheetButton;
    
    [arrayContentFromTableSheetRoot removeAllObjects];
    [arrayContentFromTableSheetRoot addObjectsFromArray:[self getSheetFromRootPathOlderBySheetNumber:sheetTablePath DefaultSheetName:sheetBtnName]]; // contiene el nombre de todas las hojas en orden ascendente
    
    if ([funtion isEqualToString:@"CREATE SHEET"]) {
        
        [arrayBtnSheet removeAllObjects];
        
        viewSheetPanelScroll = [[UIView alloc] initWithFrame:rect];
        [viewSheetPanelScroll setBackgroundColor:[UIColor clearColor]];
        [view addSubview:viewSheetPanelScroll];
        
        sheetPanelScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewSheetPanelScroll.frame.size.width, viewSheetPanelScroll.frame.size.height)];
        [sheetPanelScroll setScrollEnabled:YES];
        [sheetPanelScroll setContentSize:CGSizeMake(rect.size.width, 0)];
        [sheetPanelScroll setShowsVerticalScrollIndicator:NO];
        [viewSheetPanelScroll addSubview:sheetPanelScroll];
        
        SheetPath = @"";  // Indica que no guardara hojas secundarias. Esta en la hoja princial por defecto
        mainSheetButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 35)]; // Boton de la hoja principal
        [mainSheetButton setTitle:[NSString stringWithFormat:@"%@ 1",sheetBtnName] forState:UIControlStateNormal];
        [[mainSheetButton titleLabel] setFont:HeitiTC_14];
        [mainSheetButton setTitleColor:tableInternalButtonColor forState:UIControlStateNormal];
        [mainSheetButton setBackgroundColor:tableInternalBackGroundBtnColor];
        [mainSheetButton setTag:1];
        mainSheetButton.layer.cornerRadius = 3;
        mainSheetButton.layer.borderWidth = 0.3;
        mainSheetButton.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.1].CGColor;
        [mainSheetButton addTarget:self action:@selector(resingSheetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sheetPanelScroll addSubview:mainSheetButton];
        
        [arrayBtnSheet addObject:mainSheetButton];
        
    for (int i = 0; i < [arrayContentFromTableSheetRoot count]; i++) { // Por cada archivo que encuentre en la carpeta de hojas de la tabla actual, creara un boton que permitira cargar los datos de cada hoja.
        
        sheetButton = [[UIButton alloc] initWithFrame:CGRectMake(X, 0, 100, 35)];
        [sheetButton setTitle:[NSString stringWithFormat:@"Sheet %i",/*sheetBtnName,*/(i + 2)] forState:UIControlStateNormal];
        [[sheetButton titleLabel] setFont:HeitiTC_14];
        [sheetButton setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
        [sheetButton setTag:(i + 2)];
        sheetButton.layer.cornerRadius = 3;
        sheetButton.layer.borderWidth = 0.3;
        sheetButton.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.1].CGColor;
        [sheetButton addTarget:self action:@selector(resingSheetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sheetPanelScroll addSubview:sheetButton];
        
        X = x * (i + 2);
        [sheetPanelScroll setContentSize:CGSizeMake(X, 0)];
        [arrayBtnSheet addObject:sheetButton];  // Guardando los botones (sheet) para manejar sus atributos
    }
        
    }
    else if ([funtion isEqualToString:@"CREATE SHEET BUTTON"]) // (boton + inferior) Crea una nueva hoja en la tabla. cuando se crea una nueva hoja verifica si el archivo existe, si no existe crea el boton y la hoja en blanco, luego toma el array de datos y lo carga con string ("") para dejar espacio para los datos de la hoja. Despues de estar cargado el array, crea un archivo en la ruta /nombre de la tabla.Sheet/ con el nombre de la tabla y el numero de la hoja: (tabla 1), El archivo contendra el array de datos
    {
        NSString *sheetTablePath = [NSString stringWithFormat:@"%@/%@/%@.%@/%@ %i",rootPath,dataBaseName,tableName,sheetBtnName,sheetBtnName,(int)(numSheets + 1)];  // Ruta de la carpeta que contiene las hojas de la tabla. Las hojas se guardan en una carpeta en la misma ruta de la tabla (con PathExtention = .Sheet)
        NSString *rootFilePath = [NSString stringWithFormat:@"%@/%@/%@.%@",rootPath,dataBaseName,tableName,sheetBtnName];
        
        NSString *tempFileName;
        NSInteger n = 0;
        BOOL found = NO;
    
        if ([arrayContentFromTableSheetRoot count] > 0) { // Si existe algun archivo en la ruta
            
        while (found == NO) { // permite establecer una ruta para el archivo con el numero de hoja en forma ascendente
            
            tempFileName = [NSString stringWithFormat:@"%@ %i",sheetBtnName,(int)n];
            
            if ([tempFileName isEqualToString:[arrayContentFromTableSheetRoot lastObject]]) { // El ultimo objeto del array tendra el nombre del archivo mas reciente (sheet n....(last obj: sheet n + 1)).
                
                found = YES;
                sheetTablePath = [NSString stringWithFormat:@"%@/%@/%@.%@/%@ %i",rootPath,dataBaseName,tableName,sheetBtnName,sheetBtnName,(int)(n + 1)]; // Asigna el valor de archivo (+1): (sheet 1 --- sheet 1+1 = 2)
            }
            
            n++;
        }}
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:sheetTablePath]) { // No existe la hoja. No deberia de existir el archivo
            
            X = x * numSheets;
            [sheetPanelScroll setContentSize:CGSizeMake(X + x, 0)];
            
            sheetButton = [[UIButton alloc] initWithFrame:CGRectMake(X, 0, 100, 35)];
            [sheetButton setTitle:[NSString stringWithFormat:@"%@ %i",sheetBtnName,(int)(numSheets + 1)] forState:UIControlStateNormal];
            [[sheetButton titleLabel] setFont:HeitiTC_14];
            [sheetButton setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
            [sheetButton setTag:(numSheets + 1)];
            [sheetButton addTarget:self action:@selector(resingSheetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [sheetPanelScroll addSubview:sheetButton];
            
            [arrayBtnSheet addObject:sheetButton];  // Guardando los botones (sheet) para manejar sus atributos
            
            [arrayDataSheet removeAllObjects];
            for (int i = 0; i < [arrayField count]; i++) {
                
                [arrayDataSheet addObject:@""];
            }
            
            BOOL archived = [NSKeyedArchiver archiveRootObject:arrayDataSheet toFile:sheetTablePath];
            
            if (archived == NO) {
                [self createAlertWithTitle:@"Information" Message:@"The sheet can't be created. Please try again later." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
            }
            else if (archived == YES)
            {
            
            [arrayContentFromTableSheetRoot removeAllObjects];
            [arrayContentFromTableSheetRoot addObjectsFromArray:[self getSheetFromRootPathOlderBySheetNumber:rootFilePath DefaultSheetName:sheetBtnName]]; // contiene el nombre de todas las hojas en orden ascendente
            }
        }
    }
}

-(void)resingSheetButtonPressed:(id)sender  // RECIBE LOS BOTONES SHEET
{
    [self autoSavingDataBase];
    
    if ([sender tag] == 1) {  // Hoja principal de la tabla
        
        SheetPath = @"";  // Indica que no guardara hojas secundarias. Esta en la hoja princial actualmente
        [self loadArrayFieldDataFromPath:[NSString stringWithFormat:@"%@/%@/%@",oneDataDirPath,tempDBname,tempTBname]]; // busca en la ruta de la tabla y toma el indice 2 para cargar los datos de la tabla. Carga el array de datos
        
        NSInteger fieldNotEmpty = 0;
        for (int i = 0; i < [arrayField count]; i++) {
            
            [self writeInField:[arrayDataField objectAtIndex:i] WithTag:i];
            
            // CALCULANDO ESPACIO LIBRE EN LA HOJA ACTUAL
            if (![[arrayDataField objectAtIndex:i] isEqualToString:@""] && ![[arrayDataField objectAtIndex:i] isEqualToString:@" "]) {
                
                fieldNotEmpty ++;
                [self calculateProgressCapacityTableForNumField:[arrayField count] FieldNotEmpty:fieldNotEmpty ArrayData:nil GETFuntion:@"NONE"];
            }
        }
        
        if (fieldNotEmpty == 0) {
            [self calculateProgressCapacityTableForNumField:[arrayField count] FieldNotEmpty:fieldNotEmpty ArrayData:nil GETFuntion:@"NONE"];
        }
        
        if (![findTextFild.text isEqualToString:@""] && ![findTextFild.text isEqualToString:@" "]) {
            
            [self findDataInFieldWithText:findTextFild.text ShowButtonSheet:NO];
        }
        else
        {
            [self restoreFieldColor];
        }
    }
    else   // Hojas secundarias: Creadas manualmente.
    {
        NSString *sheetName = [NSString stringWithFormat:@"%@",[arrayContentFromTableSheetRoot objectAtIndex:(int)([sender tag] - 2)]];
        NSString * sheetPath = [NSString stringWithFormat:@"%@/%@/%@.%@/%@",oneDataDirPath,tempDBname,tempTBname,sheetBtnName,sheetName];
        
        [self loadSheetAtPath:sheetPath];
        SheetPath = sheetPath;  // Contiene la ruta de la hoja actual. Cuando se invoque el metodo [self autoSavingDataBase] al string no estar nulo, Guarda ademas de la hoja principal y el metadato de la tabla, los datos de la hoja actual.
        
        BOOL hasNewField = NO;  // Permite guardar los nuevos campos de la tabla en la hoja. Si la cantidad de textField en la tabla es mayor que los datos que posee el arrayDataSheet, Guarda un string "" en el array para reservar un espacio para los nuevos datos.
        
        if ([arrayDataSheet count] != 0) { // Si el tamano del array es diferente de cero, indica que los datos fueron guardados correctamente. Si el tamano es 0 (indica posibilidad de danos en el archivo ), creara un archivo nuevo con datos "" en el array y en la misma ruta
            
            NSInteger fieldNotEmpty = 0;
            for (int i = 0; i < [arrayField count]; i++) {
            
                [self writeInField:@"" WithTag:i]; // Borra el campo antes de insertar el valor del array
            
                if (i < [arrayDataSheet count]) { // Evita error al haber mas campos que datos en el array
          
                    [self writeInField:[arrayDataSheet objectAtIndex:i] WithTag:i];
                    
                    // CALCULANDO ESPACIO LIBRE EN LA HOJA ACTUAL
                    if (![[arrayDataSheet objectAtIndex:i] isEqualToString:@""] && ![[arrayDataSheet objectAtIndex:i] isEqualToString:@" "]) {
                        
                        fieldNotEmpty ++;
                        [self calculateProgressCapacityTableForNumField:[arrayField count] FieldNotEmpty:fieldNotEmpty ArrayData:nil GETFuntion:@"NONE"];
                    }
                }
                else  // Si hay mas campos que datos, igualara el array insertando valores vacios
                {
                    [arrayDataSheet addObject:@""];
                    hasNewField = YES;
                }
            }
            
            if (fieldNotEmpty == 0) {
                [self calculateProgressCapacityTableForNumField:[arrayField count] FieldNotEmpty:fieldNotEmpty ArrayData:nil GETFuntion:@"NONE"];
            }
        }
        else if ([arrayDataSheet count] == 0) // Indica que el array no cargo correctamente por danos en el archivo. Sobreescribira los datos con String vacios ("")
        {
            [arrayDataSheet removeAllObjects];
            [self fixFileAtPath:sheetPath AmountOfFieldOnTable:[arrayField count]];
        }
        
        if (hasNewField == YES) { // Hubieron cambios en el tamano del array. La cantidad de textfield es mayor que la cantidad de datos en array.
            [self saveSheetAtPath:sheetPath]; // Guarda los nuevos cambios en el array
            hasNewField = NO;
        }
        
        if (![findTextFild.text isEqualToString:@""] && ![findTextFild.text isEqualToString:@" "]) {
    
        [self findDataInFieldWithText:findTextFild.text ShowButtonSheet:NO];
        }
        else
        {
            [self restoreFieldColor];
        }
    }
    [self lightSheetPressedButtonInTag:[sender tag]]; // Permite indicar la hoja presionada. Establece el color de letras y fondo del boton
}

-(void)lightSheetPressedButtonInTag:(NSInteger )tag  // ESTABLECE EL COLOR DE LETRAS Y FONDO DE LOS BOTONES (SHEET)
{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if ([findTextFild.text isEqualToString:@""] || [findTextFild.text isEqualToString:@" "]) {
        
        if (tag == 1) {
            
            [mainSheetButton setTitleColor:tableInternalButtonColor forState:UIControlStateNormal];
            [mainSheetButton setBackgroundColor:tableInternalBackGroundBtnColor];
        }
        else if (tag > 1)
        {
            [(UIButton *)[arrayBtnSheet objectAtIndex:(tag - 1)] setTitleColor:tableInternalButtonColor forState:UIControlStateNormal];
            [(UIButton *)[arrayBtnSheet objectAtIndex:(tag - 1)] setBackgroundColor:tableInternalBackGroundBtnColor];
            [mainSheetButton setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
            [mainSheetButton setBackgroundColor:normalStateTableInternalBackGroundBtnColor];
        }
        
        for (int i = 0; i < [arrayBtnSheet count]; i++) {
            
            if (i != (tag - 1)) {
                
                [(UIButton *)[arrayBtnSheet objectAtIndex:(i)] setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
                [(UIButton *)[arrayBtnSheet objectAtIndex:(i)] setBackgroundColor:normalStateTableInternalBackGroundBtnColor];
            }}
    }
    else
    {
        if (tag == 1) {
            
            [mainSheetButton setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
            [mainSheetButton setBackgroundColor:normalStateTableInternalBackGroundBtnColor];
        }
        else if (tag > 1)
        {
            [(UIButton *)[arrayBtnSheet objectAtIndex:(tag - 1)] setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
            [(UIButton *)[arrayBtnSheet objectAtIndex:(tag - 1)] setBackgroundColor:normalStateTableInternalBackGroundBtnColor];
        }
    }
    [UIView commitAnimations];
}

-(void)loadArrayFieldDataFromPath:(NSString *)TablePath
{
    NSMutableArray *TableData = [[NSMutableArray alloc] initWithCapacity:0];
    TableData = [self loadTableAtPath:TablePath];
    
    [arrayDataField removeAllObjects];
    arrayDataField = [TableData objectAtIndex:2];
    [TableData removeAllObjects];
}
-(void)loadSheetAtPath:(NSString *)path  // Carga los datos de las hojas
{
    [arrayDataSheet removeAllObjects];
    arrayDataSheet = [self loadTableAtPath:path];
}
-(void)saveSheetAtPath:(NSString *)path  // GUARDA LOS DATOS DE LA HOJA. El metodo que invoca esta funcion es [autoSavingDataBase]
{
    if (![path isEqualToString:@""]) {  // Si no esta en la hoja principal captura los datos de cada campo. La ruta (SheetPath) indica en que hoja guardara los datos recopilados
        
        for (int i = 0; i < [arrayField count]; i++) {
            
            [arrayDataSheet replaceObjectAtIndex:i withObject:[self getTextForFieldInTag:i]];
        }
        
        BOOL archived = [NSKeyedArchiver archiveRootObject:arrayDataSheet toFile:path];
        
        if (archived == NO) {
            [self createAlertWithTitle:@"Sheet" Message:@"The sheet can't be created. Please try again later." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
    }
}

# pragma REPARA UN ARCHIVO EN UNA RUTA ESPECIFICADA
-(void)fixFileAtPath:(NSString *)path AmountOfFieldOnTable:(NSInteger )amountField
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int p = 0; p < amountField; p++) {
        
        [array addObject:@""];
    }
    
    [NSKeyedArchiver archiveRootObject:array toFile:path]; // Crea un archivo en la misma ruta, y con datos ""
}

# pragma OBTIENE EL NOMBRE DE LOS ARCHIVOS ORDENADOS EN FORMA ASCENDENTE
-(NSMutableArray *)getSheetFromRootPathOlderBySheetNumber:(NSString *)path DefaultSheetName:(NSString *)sheetName
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *arrayContentFile = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *lookingForSheet;
    
    int lenght = 0;
    
    for (int i = 0; i < [arrayContentFile count]; i ++) {  // Obteniendo el tamano del nombre del archivo mas largo
        
        if (lenght < [[arrayContentFile objectAtIndex:i] length]) {
            
            lenght = (int)[[arrayContentFile objectAtIndex:i] length];
        }
    }
    
        for (int a = 1; a > 0; a++) {  // Asigna un nombre al string en forma ascendente segun el numero de hojas.
            
            lookingForSheet = [NSString stringWithFormat:@"%@ %i",sheetName, a];
            
            if ([lookingForSheet length] <= lenght) { // Verifica que el tamano del string lookingForSheet no sea mayor al nombre del archivo mas largo en el array
                
                for (int p = 0; p < [arrayContentFile count]; p++) {  //Busca en todo el array. Busca el nombre en orden ascendente de (lookingForSheet) en el array
                    
                    if ([lookingForSheet isEqualToString:[arrayContentFile objectAtIndex:p]]) {
                        
                        [array addObject:[arrayContentFile objectAtIndex:p]];
                    }
                    else // Si no lo encuentra, continua
                    {
                        continue;
                    }
                }
            }
            else // Los caracteres de lookingForSheet son mayores a los del nombre del archivo buscado (sheet 10 > sheet 1). No existe el nombre asignado en la ruta
            {
                break;
            }
        }
    
    return array;
}

# pragma CREA EL BOTON ERASE SHEET
-(void)createEraseSheetBtnWithFrame:(CGRect )rect InView:(UIView *)view
{
    UIButton *eraseSheetBtn = [[UIButton alloc] initWithFrame:rect];
    [eraseSheetBtn setImage:[UIImage imageNamed:@"removeSheet.png"] forState:UIControlStateNormal];
    [eraseSheetBtn setTag:12];
    [eraseSheetBtn addTarget:self action:@selector(resingTableButtonsPressed:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:eraseSheetBtn];
}

# pragma BORRA LA HOJA ACTUAL // (Archivo)
-(void)eraseSheetAtPath:(NSString *)path
{
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    [viewSheetPanelScroll removeFromSuperview];
    [arrayBtnSheet removeAllObjects];
    [arrayDataSheet removeAllObjects];
    SheetPath = @"";
    
    [self createSheetButtonWithSheetPanelFrame:CGRectMake(50, excelTableView.frame.size.height - 35, excelTableView.frame.size.width - 80, 30) TableName:tempTBname DataBaseName:tempDBname RootPath:oneDataDirPath InView:excelTableView ORCreateSheetButtonWithNumOfSheetButtons:[arrayBtnSheet count] FUNTION:@"CREATE SHEET"]; // Funtion Create sheet: Crea el scroll que contendra los botones sheet y el boton principal. Funtion create sheet button: crea un boton (sheet)

    [self autoSetDataFromArray:arrayDataField InFieldForArrayFields:arrayField]; // Inserta los datos del arrayDataField en cada textField
}

# pragma CALCULA EL ESPACIO LIBRE DE LA TABLA (FUNTION: ARRAY / NONE)
-(void)calculateProgressCapacityTableForNumField:(NSInteger )numFields FieldNotEmpty:(NSInteger )capacity ArrayData:(NSMutableArray *)arrayData GETFuntion:(NSString *)funtion
{
    if ([funtion isEqualToString:@"ARRAY"]) {  // Obtiene la capacidad de la tabla a partir del array de datos
        
        capacity = 0;
        for (int i = 0; i < [arrayData count]; i++) {
            
            if (![[arrayData objectAtIndex:i] isEqualToString:@""] && ![[arrayData objectAtIndex:i] isEqualToString:@" "]) {
                
                capacity ++;
            }
        }
    }
    
    if ([ModeGraphORConsol isEqualToString:consoleTableMode]) {
        numFields = [arrayData count];
    }
    
    [capacityTable setProgress:((capacity * 1.0) / numFields) animated:YES];
}

#pragma CONVIERTE DE TAG A COORDENADAS
-(NSString *)convertInCoordinatesFromTag:(NSInteger )tag numRows:(NSInteger )numRows
{
    NSInteger xRow = (tag) % numRows + 1;
    NSInteger yCol = ((tag) / numRows) + 1;
    
    coorYcol = yCol;
    coorXrow = xRow;
    NSString *resul = [NSString stringWithFormat:@"(%i,%i)",(int)xRow,(int)yCol];
    
    return resul;
}
#pragma CONVIERTE DE COORDENADAS A TAG
-(NSInteger )convertToTagFromCoordinateXrow:(NSInteger )row Ycol:(NSInteger )col NumRows:(NSInteger )numRows
{
    NSInteger tagResult = row + numRows * (col - 1);
    return tagResult;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignFirstResponder];
    [KeyTimerProcesing invalidate];  // Invalida el temporizador que estuvo corriendo anteriormente
    [KeyTimerProcesing2 invalidate];  // Invalida el temporizador que estuvo corriendo anteriormente
    
    if (![ModeGraphORConsol isEqualToString:externConsultTableMode]) { // Indica que esta dentro de la tabla y esta construida en modo grafico (con textfield) o consola, por lo tanto, el ConsoleView que movera esta siendo usado para presentar los resultados de la consulta. En caso de una consulta externa (fuera de la tabla) el array estara vacio, no permitira movimiento en ese caso.
    
    // Permite mover de posicion el console view (Resultados de la consulta)
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:tableConsoleView];
    
    if ((point.x < 40 && point.x > 0) && (point.y < 40 && point.y > 0)) {
        canMoveConsoleView = YES;
    }}
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [KeyTimerProcesing invalidate];  // Invalida el temporizador que estuvo corriendo anteriormente
    [KeyTimerProcesing2 invalidate];  // Invalida el temporizador que estuvo corriendo anteriormente
    
    [self changeTextColorToFieldInTag:textField.tag];
    
    [self KeyProcessingWithArrayPK:arrayKeyBoardFieldType FieldTag:textField.tag NumRows:fila];   // No pertime la entrada de un tipo de dato diferente del asignado
    
    [self setUpPrimaryKeyInFieldsWithTag:textField.tag NumOfRows:fila ByArrayPrimaryKeyStatement:arrayKeyBoardFieldType];
  
    [self setOriginalStateForFieldInTag:(textField.tag)];  // Establece el color original del campo seleccionado
    
    currentDataInField = [self getTextForFieldInTag:textField.tag];  // Obtiene el dato contenido en el textfield presionado para compararlo con el dato que tendra cuando se quite el foco. Si son diferentes guardara los datos de la tabla.
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [KeyTimerProcesing invalidate];  // Invalida el temporizador que estuvo corriendo anteriormente
    [KeyTimerProcesing2 invalidate];  // Invalida el temporizador que estuvo corriendo anteriormente
    
    [self restoreFieldColor];
    
    if (!([currentDataInField isEqualToString:[self getTextForFieldInTag:textField.tag]])) { // verifica si ubieron cambios en el dato del textField actual.
        
        [self autoSavingDataBase]; // Guarda la base de datos
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat xSize = scrollView.bounds.size.width;
    NSInteger xValues = scrollView.contentOffset.x + (0.01f * xSize ) / xSize;
    
    CGFloat ySize = scrollView.bounds.size.height;
    NSInteger yValues = scrollView.contentOffset.y + (0.01f * ySize ) / ySize;
    
    if (scrollView.tag == 0) {   // Scroll grafico
  
    [xViewExcelLabels setFrame:CGRectMake(-1 * xValues, 0, xViewExcelLabels.frame.size.width, 50)];
    [yViewExcelLabels setFrame:CGRectMake(0, -1 * yValues, 50, yViewExcelLabels.frame.size.height)];
    }
    else if (scrollView.tag == 1)  // Scroll consola
    {
    
    [consoleFieldName setFrame:CGRectMake(-1 * xValues, 0, consoleFieldName.frame.size.width, 40)];
    [lineNumber setFrame:CGRectMake(0, -1 * yValues, 40, lineNumber.frame.size.height)];
    }
    else if (scrollView.tag == 2)  // Scroll consola Cuando el modo de entrada de la tabla es en consola
    {
        
        [consoleFieldName setFrame:CGRectMake(-1 * xValues, 0, consoleFieldName.frame.size.width, 40)];
        [lineNumber setFrame:CGRectMake(0, -1 * yValues, 40, lineNumber.frame.size.height)];
    }
    
    [deleteTimer invalidate];
}
#pragma CAMBIA EL COLOR DEL CAMPO SELECCIONADO
-(void)changeTextColorToFieldInTag:(NSInteger )tag
{
    [(UITextField*)[arrayField objectAtIndex:(tag)] setTextColor:[UIColor colorWithRed:0 green:0.5 blue:1.0 alpha:1.0]];
}
#pragma ESCRIBE EN EL CAMPO INDICADO
-(void) writeInField:(NSString *)writtenMsg WithTag:(NSInteger )tag
{
    [(UITextField*)[arrayField objectAtIndex:(tag)] setText:writtenMsg];
}

#pragma OBTIENE EL TEXTO DEL CAMPO INDICADO
-(NSString *)getTextForFieldInTag:(NSInteger )tag
{
    return [(UITextField*)[arrayField objectAtIndex:tag] text];
}

# pragma RESTAURA EL COLOR DE LOS CAMPOS
-(void)restoreFieldColor
{
    if ([arrayColorFieldDataFound count] > 0) {
        
        NSInteger index = 0;
        for (int i = 0; i < [arrayColorFieldDataFound count]; i++) {
            
            index = [[arrayColorFieldDataFound objectAtIndex:i] intValue];
            
            [self convertInCoordinatesFromTag:index numRows:fila];
            
            [(UILabel *)[arrayOBfieldNames objectAtIndex:coorYcol-1] setBackgroundColor:[UIColor clearColor]];
            [(UILabel *)[arrayOBNumRows objectAtIndex:coorXrow-1] setBackgroundColor:[UIColor clearColor]];
            [(UILabel *)[arrayOBfieldNames objectAtIndex:coorYcol-1] setTextColor:[UIColor grayColor]];
            [(UILabel *)[arrayOBNumRows objectAtIndex:coorXrow-1] setTextColor:[UIColor grayColor]];
            [[(UITextField*)[arrayField objectAtIndex:(index)] layer] setBorderColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor];
        }
        [arrayColorFieldDataFound removeAllObjects];
    }
}

# pragma BUSCA TEXTOS EN LA TABLA
-(void)findDataInFieldWithText:(NSString *)findText ShowButtonSheet:(BOOL)showButtonSheet
{
    [arrayDataFound removeAllObjects];
    
    [self restoreFieldColor]; // Estableciendo el color normal de los campos
    
    for (int i = 0; i < [arrayField count]; i ++) {
        
        if ([findText isEqualToString:[self getTextForFieldInTag:i]]) {
            
            [UIView beginAnimations:NULL context:NULL];
            [UIView setAnimationDuration:0.4];
            [[(UITextField*)[arrayField objectAtIndex:(i)] layer] setBorderColor:[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0].CGColor];
            
            if (showButtonSheet == YES) {
                
            [mainSheetButton setTitleColor:tableInternalButtonColor forState:UIControlStateNormal];
            [mainSheetButton setBackgroundColor:tableInternalBackGroundBtnColor];
            }
            [UIView commitAnimations];
            
            [self showDataFoundForFieldInTag:i];
            [arrayDataFound addObject:[self getTextForFieldInTag:i]]; // Guarda el dato encontrado en el textfield
            [arrayColorFieldDataFound addObject:[NSString stringWithFormat:@"%i",i]]; // Guardando el tag del field encontrado para luego reestablecer su color
        }
    }
 
    if (showButtonSheet == YES) {
 
    [self findOrReplaceOnSheetFuntion:@"FIND" DataText:findText DataToReplace:nil]; // Buscar el dato de las hojas
    }
}
# pragma REEMPLAZA EL TEXTO DE UN CAMPO POR OTRO
-(void)replaceDataInFieldWithText:(NSString *)textInField ForData:(NSString *)dataReplaced
{  // Antes de sobreescribir los datos de la tabla con los del array de datos, carga y llena los campos con los datos del array (hoja principal: NO 1) para evitar perder los datos de dicha hoja. Si se saltan estas sentencias, cuando se presiones sobre una hoja y se cargen los campos con los datos el array de hojas (arrayDataSheet) de dicha hoja, al momento de guardar sobreecribira los datos de la hoja principal con los de la hoja actual (tomara los datos de los campos y los guardara en el array de datos (arrayDataField)).
    
    [self loadArrayFieldDataFromPath:[NSString stringWithFormat:@"%@/%@/%@",oneDataDirPath,tempDBname,tempTBname]]; // busca en la ruta de la tabla y toma el indice 2 para cargar los datos de la tabla
    
    for (int i = 0; i < [arrayField count]; i++) {
        
        if ([textInField isEqualToString:[arrayDataField objectAtIndex:i]]) {
            
            [self writeInField:dataReplaced WithTag:i];
        }
        else
        {
            [self writeInField:[arrayDataField objectAtIndex:i] WithTag:i];
        }
    }
    
    SheetPath = @""; // No permitira que guarde las demas hojas con los datos reemplazados. Solo guardara la hoja principal.
    [self autoSavingDataBase]; // Guarda los datos reemplazados de la hoja principal. Los datos se recogen manualmente desde los campos.
    
    [self findOrReplaceOnSheetFuntion:@"REPLACE" DataText:textInField DataToReplace:dataReplaced]; // Remplazar el dato de las hojas
}

-(void)findOrReplaceOnSheetFuntion:(NSString *)funtion DataText:(NSString *)dataText DataToReplace:(NSString *)dataToReplace
{
        // Busca en las hojas de la tabla
        NSString *sheetTablePath = [NSString stringWithFormat:@"%@/%@/%@.%@",oneDataDirPath,tempDBname,tempTBname,sheetBtnName]; // Ruta de la carpeta de hojas
    
        if ([[NSFileManager defaultManager] fileExistsAtPath:sheetTablePath]) {  // Si existe una carpeta una carpeta con el nombre de la tabla.Sheet (hay varias hojas en la tabla).
            
            NSString *sheetFile;
            
            for (int i = 0; i < [arrayContentFromTableSheetRoot count]; i++) {
                
                sheetFile = [NSString stringWithFormat:@"%@/%@",sheetTablePath,[arrayContentFromTableSheetRoot objectAtIndex:i]]; // Ruta del archivo (hoja).
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:sheetFile]) {
                 
                [self loadSheetAtPath:sheetFile];  // Carga el arraydataSheet con los datos de la tabla
                }
                else
                {
                    continue;
                }
                
                if (arrayDataSheet != 0) { // Evita errores por perdida de archivos (Archivo danado o borrado).
                    
                for (int c = 0; c < [arrayField count]; c ++) { // permite recorrer el array de hojas completo.
                    
                if ([funtion isEqualToString:@"FIND"]){
                    
                    if ([arrayDataSheet count] > (c + 1)) { // Evita errores
                        
                        if ([dataText isEqualToString:[NSString stringWithFormat:@"%@",[arrayDataSheet objectAtIndex:c]]]) {
                        
                        [(UIButton *)[arrayBtnSheet objectAtIndex:(i + 1)] setTitleColor:tableInternalButtonColor forState:UIControlStateNormal]; // Establece el color del boton (sheet) en indice ya que las hojas se guardan de la segunda en adelante en la carpeta tablename.sheet. La primera hoja se guarda por defecto con la configuracion de la tabla.
                        [(UIButton *)[arrayBtnSheet objectAtIndex:(i + 1)] setBackgroundColor:tableInternalBackGroundBtnColor];
                        }
                    }
                    else if ([arrayDataSheet count] < (c + 1))
                    {
                        [arrayDataSheet addObject:@""];
                    }
                }
                else if ([funtion isEqualToString:@"REPLACE"])
                {
                    if ([arrayDataSheet count] > (c + 1)) { // Evita errores
                        
                        if ([dataText isEqualToString:[NSString stringWithFormat:@"%@",[arrayDataSheet objectAtIndex:c]]]) {
                        
                        [arrayDataSheet replaceObjectAtIndex:c withObject:dataToReplace];
                        }
                    }
                }} // END FOR
            }// End condicion [ArrayDataSheet count] > 0
            else if (arrayDataSheet == 0) // Archivo de datos danado
            {
                [self fixFileAtPath:sheetFile AmountOfFieldOnTable:[arrayField count]];
            }
                
                if ([funtion isEqualToString:@"REPLACE"]) {  // Guarda los datos reemplazados
              
                    BOOL archived = [NSKeyedArchiver archiveRootObject:arrayDataSheet toFile:sheetFile]; // Almacena los datos reemplazados en la misma ruta del archivo
                    
                    if (archived == NO) {
                        [self createAlertWithTitle:@"Sheet" Message:@"The sheet can't be created. Please try again later." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
                    }
                }
            }
        }
}

# pragma MUESTRA EN QUE CAMPO Y FILA SE ENCUENTRA UN DATO BUSCADO
-(void)showDataFoundForFieldInTag:(NSInteger)tag  // Establece el color de fondo en los nombres de los campos y en el numero filas que se encuentra el dato buscado. Convierte el tag del objeto encontrado en coordenadas el cual indican en que campo y fila se encuentra el dato encontrado. Los arrays se borran cuando el usuario sale de la tabla (presiona BACK) para mantenerlo vacio para la sigte tabla. Cuando el usuario presiona sobre el objeto encontrado, este, el campo y el num de fila vuelven a su estado normal (campo y columna color gris, y texto del campo negro) invocando el metodo setOriginalStateForFieldInTag.
{
    [self convertInCoordinatesFromTag:tag numRows:fila];
    
    [(UILabel *)[arrayOBfieldNames objectAtIndex:coorYcol-1] setTextColor:[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0]];
    [(UILabel *)[arrayOBNumRows objectAtIndex:coorXrow-1] setTextColor:[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0]];
    [(UILabel *)[arrayOBfieldNames objectAtIndex:coorYcol-1] setBackgroundColor:[UIColor whiteColor]];
    [(UILabel *)[arrayOBNumRows objectAtIndex:coorXrow-1] setBackgroundColor:[UIColor whiteColor]];
}
# pragma ESTABLECE EL COLOR ORIGINAL DEL CAMPO Y FILA DEL DATO ENCONTRADO
-(void)setOriginalStateForFieldInTag:(NSInteger)tag
{
    for (int i = 0; i < [arrayDataFound count]; i++) {
        
        if ([[arrayDataFound objectAtIndex:i] isEqualToString:[self getTextForFieldInTag:tag]]) {  // si el dato del textfield fue encontrado reestablecera las propiedades de los objetos y borrara dicho dato
            
            [self convertInCoordinatesFromTag:tag numRows:fila];
    
            [(UILabel *)[arrayOBfieldNames objectAtIndex:coorYcol-1] setBackgroundColor:[UIColor clearColor]];
            [(UILabel *)[arrayOBNumRows objectAtIndex:coorXrow-1] setBackgroundColor:[UIColor clearColor]];
            [(UILabel *)[arrayOBfieldNames objectAtIndex:coorYcol-1] setTextColor:[UIColor grayColor]];
            [(UILabel *)[arrayOBNumRows objectAtIndex:coorXrow-1] setTextColor:[UIColor grayColor]];
            [[(UITextField*)[arrayField objectAtIndex:(tag)] layer] setBorderColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor];
           // [(UITextField *)[arrayField objectAtIndex:(tag)] setTextColor:[UIColor grayColor]];
        
            [arrayDataFound removeObjectAtIndex:i];
            break;
        }
    }
}

# pragma INSERTA LOS DATOS DEL ARRAY (ArrayDataField) EN CADA CAMPO (TextField) DE LA TABLA
-(void)autoSetDataFromArray:(NSMutableArray *)arrayData InFieldForArrayFields:(NSMutableArray *)arrayFields
{
        for (int i = 0; i < [arrayFields count]; i++) {
            
            [self writeInField:[arrayData objectAtIndex:i] WithTag:i];
        }
}

# pragma GUARDA LA INFORMACION DE LA TABLA Y LA BASE DE DATOS
-(void)autoSavingDataBase  // Guarda la tabla y su contenido en la base de datos actual. Guarda cuando se presiona el boton atras de la tabla (antes de salir de la tabla), Cuando se introduce un valor en el campo y se oculta el teclado (cuando termina de entrar un dato en el campo) y de manera manual; cuando se presiona el boton Guardar
{
    if ([arrayField count] > 0 && [ModeGraphORConsol isEqualToString:graphicsTableMode]) {
    
    NSInteger fieldNotEmpty = 0;
    for (int i = 0; i < [arrayField count]; i++) {
        
        if ([SheetPath isEqualToString:@""]) {  // Solo captura los datos de cada campo si esta en la hoja principal.
    
            [arrayDataField replaceObjectAtIndex:i withObject:[self getTextForFieldInTag:i]];
        }
        
        // ESPACIO LIBRE DE LA TABLA
        if (![[self getTextForFieldInTag:i] isEqualToString:@""] && ![[self getTextForFieldInTag:i] isEqualToString:@" "]) {
            
            fieldNotEmpty ++;
            [self calculateProgressCapacityTableForNumField:[arrayField count] FieldNotEmpty:fieldNotEmpty ArrayData:nil GETFuntion:@"NONE"];
        }
    }
  
    if (fieldNotEmpty == 0) {
        
        [self calculateProgressCapacityTableForNumField:[arrayField count] FieldNotEmpty:fieldNotEmpty ArrayData:nil GETFuntion:@"NONE"];
    }
    
    [self SaveDataBaseWithName:DBName TableName:DBTableName TableContents:[self setTableDatas_TableName:DBTableName ArrayFieldNames:arrayFieldNames ArrayDataFields:arrayDataField] TableMetadata:[self setTableMetadatas_numcolFields:numOfColField PrimaryKey:arrayKeyBoardFieldType]];
    
    [self saveSheetAtPath:SheetPath]; // Si la ruta no esta nula (""), Guardara los datos de la hoja
    }
}

# pragma EDITA EL NOMBRE DE LA BASE DE DATOS (FUNTION: Rename / BackUp)
-(void)editDataBaseName:(NSString *)dbName AtPath:(NSString *)path WithName:(NSString *)name RootPath:(NSString *)rootPath Funtion:(NSString *)funtion// Busca las tablas de la base de datos seleccionada y las invoca con la funcion NONE (indica que solo cargara los array con el contenido de la tabla sin contruirla), luego guarda la tabla en una carpeta (DB) con el nombre de la base de datos establecida.
{
    NSString *newDBPath = [NSString stringWithFormat:@"%@/%@",rootPath,name]; // Ruta de la carpeta de la nueva base de datos. El nombre de la carpeta es el nombre de la base de datos.
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:newDBPath]) {
  
    [[NSFileManager defaultManager] createDirectoryAtPath:newDBPath withIntermediateDirectories:NO attributes:nil error:nil]; // Nueva base de datos
    }
    
    NSString *tableName;  // Nombre de la tabla
    NSString *tablePath;  // Ruta de la tabla
    NSString *tableSheetPath;  // Ruta de la carpeta de hojas (TableName.Sheet)
    NSString *sheetFileName;   // Contiene el nombre de una hoja
    NSString *NewTableSheetPath;  // Ruta de la nueva carpeta de hojas
    NSString *tablePasswords; // Ruta de la carpeta de contrasenas
    NSString *NewTablePassWords;  // Nueva ruta que contendra las contrasenas de las tabla (carpeta password)
    NSString *selfQueryFolderField; // Ruta de la carpeta de historial de querys
    NSString *NewQueryFolderField; // Nueva ruta que contendra los querys guardados
    for (int i = 0; i < [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil] count]; i++) {
        
        if (![[[[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil] objectAtIndex:i] pathExtension] isEqualToString:@"Metadata"] && ![[[[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil] objectAtIndex:i] pathExtension] isEqualToString:sheetBtnName] && ![[[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil] objectAtIndex:i] isEqualToString:passFolderName] && ![[[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil] objectAtIndex:i] isEqualToString:queryFolderName]) {
   
            tableName = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil] objectAtIndex:i]; // Nombre de la tabla
            tablePath = [NSString stringWithFormat:@"%@/%@",path,tableName];
            tableSheetPath = [NSString stringWithFormat:@"%@.%@",tablePath,sheetBtnName]; // Carpeta de las hojas: posee el mismo nombre de la tabla (con extension .Sheet)
            tablePasswords = [NSString stringWithFormat:@"%@/%@",path,passFolderName]; // Contiene todas las contrasenas de las tablas de la base de datos actual
            NewTablePassWords = [NSString stringWithFormat:@"%@/%@",newDBPath,passFolderName];  // Nueva ruta donde se guardaran las contrasenas
            selfQueryFolderField = [NSString stringWithFormat:@"%@/%@",path,queryFolderName];
            NewQueryFolderField = [NSString stringWithFormat:@"%@/%@",newDBPath,queryFolderName]; // Nueva ruta donde se guardaran los querys
        
            
            [self allocTableWithDataBaseName:tempDBname AtPath:tablePath FUNTION:@"NONE" MODE:ModeGraphORConsol]; // Carga los datos de la DB seleccionada. la funcion none indica que no creara la tabla, solo cargara sus atributos.
            
            [self saveTableName:DBTableName TableContents:[self setTableDatas_TableName:DBTableName ArrayFieldNames:arrayFieldNames ArrayDataFields:arrayDataField] TableMetadata:[self setTableMetadatas_numcolFields:numOfColField PrimaryKey:arrayKeyBoardFieldType] inDBPath:newDBPath];

                
                if ([[NSFileManager defaultManager] fileExistsAtPath:tableSheetPath]) { // Existe una tabla que utilize varias hojas? (nom tabla.Sheet)
                    
                    NewTableSheetPath = [NSString stringWithFormat:@"%@/%@.%@",newDBPath,tableName,sheetBtnName]; // Ruta (nombre de la tabla.Sheet) en la carpeta correspondiente a la tabla.
                    
                    if (![[NSFileManager defaultManager] fileExistsAtPath:NewTableSheetPath]) // crea la carpeta de las hojas de la tabla al lado de la tabla: (tabla...//...tabla.Sheet)
                        
                        [[NSFileManager defaultManager] createDirectoryAtPath:NewTableSheetPath withIntermediateDirectories:NO attributes:nil error:nil];  // Carpeta de las hojas de una tabla especifica
                    }
            
                for (int i = 0; i < [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:tableSheetPath error:nil] count]; i++) {
                
                    sheetFileName = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:tableSheetPath error:nil] objectAtIndex:i];
                    
                    BOOL sheetSaved = [NSKeyedArchiver archiveRootObject:[self getDataTableSheetAtPath:[NSString stringWithFormat:@"%@/%@",tableSheetPath,sheetFileName]] toFile:[NSString stringWithFormat:@"%@/%@",NewTableSheetPath,sheetFileName]];
                    
                    if (sheetSaved == NO) {
                        [self createAlertWithTitle:@"The table sheets can't be saved" Message:nil CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
                    }
                }
            
            
            if ([[self lookForTableKeyAtDBPath:path WithTableName:tableName Funtion:@"GET" ForCasePOSTSetTheReferenceQuestion:nil Password:nil] count] != 0) {
    
                [self lookForTableKeyAtDBPath:newDBPath WithTableName:tableName Funtion:@"POST" ForCasePOSTSetTheReferenceQuestion:[[self lookForTableKeyAtDBPath:path WithTableName:tableName Funtion:@"GET" ForCasePOSTSetTheReferenceQuestion:nil Password:nil] objectAtIndex:0] Password:[[self lookForTableKeyAtDBPath:path WithTableName:tableName Funtion:@"GET" ForCasePOSTSetTheReferenceQuestion:nil Password:nil] objectAtIndex:1]];
            }
            
            // Copia el historial de query de la base de datos procesada
            if ([[NSFileManager defaultManager] fileExistsAtPath:selfQueryFolderField]) { // Existe la carpeta con los querys en la db actual (en proceso)?
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:NewQueryFolderField]) {
                    
                    [[NSFileManager defaultManager] createDirectoryAtPath:NewQueryFolderField withIntermediateDirectories:NO attributes:nil error:nil];
                }
                
                NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:0];
                NSString *fileName;
                
                for (int i = 0; i < [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:selfQueryFolderField error:nil] count]; i++) {
                    
                    fileName = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:selfQueryFolderField error:nil] objectAtIndex:i]; // Nombre del archivo
                    
                    array = [self loadQueryUsedRecentlyFromPath:[NSString stringWithFormat:@"%@/%@",selfQueryFolderField,fileName]];
                    
                  BOOL saved = [NSKeyedArchiver archiveRootObject:array toFile:[NSString stringWithFormat:@"%@/%@",NewQueryFolderField,fileName]]; // Guardando array (Historial de query) en la nueva base de datos.
                    
                    if (saved == NO) {
                        [self createAlertWithTitle:@"The query's history data can not be saved." Message:nil CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
                    }
                }
            }
            
        }
    }

    if ([funtion isEqualToString:@"Rename"]) {
   
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil]; // borra la base de datos original y deja la copia con el su nuevo nombre
    }
}

# pragma CARGA LAS HOJAS DE LAS TABLAS
-(NSMutableArray *)getDataTableSheetAtPath:(NSString *)path
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

# pragma ALMACENA EN UN ARRAY (ArrayTables) EL NOMBRE DE LA TABLA, SUS CAMPOS Y EL DATO DE CADA CAMPO
-(NSMutableArray *)setTableDatas_TableName:(NSString *)TableName ArrayFieldNames:(NSMutableArray *)arrayFieldNames ArrayDataFields:(NSMutableArray *)arrayDataFields
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    
    [array addObject:TableName];
    [array addObject:arrayFieldNames];
    [array addObject:arrayDataFields];
    return array;
}

# pragma ALMACENA EN UN ARRAY (ArrayTableMetadata) LA CANTIDAD DE FILAS, Y EL TIPO DE DATO DE CADA CAMPO
-(NSMutableArray *)setTableMetadatas_numcolFields:(NSInteger) numFields PrimaryKey:(NSMutableArray *)arrayPKey
{
    NSMutableArray *arrayMetadata = [[NSMutableArray alloc] initWithCapacity:0];
    
    [arrayMetadata addObject:[NSString stringWithFormat:@"%i",(int)numFields]];
    [arrayMetadata addObject:arrayPKey];
    return arrayMetadata;
}

#pragma GUARDA LA BASE DE DATOS CON SUS TABLAS Y METADATO
-(void)SaveDataBaseWithName:(NSString *)DBName TableName:(NSString *)TableName TableContents:(NSMutableArray *)tableContents TableMetadata:(NSMutableArray *)tableMetadata
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    NSString *oneDataDir = [documentDirectory stringByAppendingString:@"/OneData"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:oneDataDir]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:oneDataDir withIntermediateDirectories:NO attributes:nil error:nil];
        [self dataBaseName:DBName TableName:TableName TableContents:tableContents TableMetadata:tableMetadata InPathRootDirectory:oneDataDir];
    }
    else
    {
        [self dataBaseName:DBName TableName:TableName TableContents:tableContents TableMetadata:tableMetadata InPathRootDirectory:oneDataDir];
    }
}
-(void)dataBaseName:(NSString *)DBName TableName:(NSString *)tableName TableContents:(NSMutableArray *)tableContents TableMetadata:(NSMutableArray *)tableMetadata InPathRootDirectory:(NSString *)rootPath
{
    NSString *DBPath = [NSString stringWithFormat:@"%@/%@",rootPath,DBName]; // Ruta de la carpeta de la nueva base de datos. El nombre de la carpeta es el nombre de la base de datos. Cada tabla se guarda con su metadato (nombre de la tabla .Metadata).
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:DBPath]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:DBPath withIntermediateDirectories:NO attributes:nil error:nil];
        
        [self saveTableName:tableName TableContents:tableContents TableMetadata:tableMetadata inDBPath:DBPath];
    }
    else
    {
        [self saveTableName:tableName TableContents:tableContents TableMetadata:tableMetadata inDBPath:DBPath];
    }
}
-(void)saveTableName:(NSString *)tableName TableContents:(NSMutableArray *)tableContents TableMetadata:(NSMutableArray *)tableMetadata inDBPath:(NSString *)Path
{
    NSString *FilePath = [NSString stringWithFormat:@"%@/%@",Path,tableName];
    NSString *FilePathMetadata = [NSString stringWithFormat:@"%@.Metadata",FilePath];
    
    BOOL tableSuccess = [NSKeyedArchiver archiveRootObject:tableContents toFile:FilePath];   // Guarda la tabla
    BOOL tableMetadataSuccess = [NSKeyedArchiver archiveRootObject:tableMetadata toFile:FilePathMetadata];   // Guarda el metadato de la tabla
    
    if (tableSuccess == YES && tableMetadataSuccess == YES) {
        
      //  [self createAlertWithTitle:@"Success" Message:nil CancelBtnTitle:@"OK" OtherBtnTitle:nil];
    }
    else
    {
        [self createAlertWithTitle:@"Cannot save the datas, please try again later" Message:nil CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
    }
    
    NSLog(@"Guardando Tabla: %@ En: %@",tableName,FilePath);
}

#pragma CARGA LA TABLA DESDE UN RUTA ESPECIFICADA
-(NSMutableArray *)loadTableAtPath:(NSString *)DBPath
{
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:DBPath];
}

# pragma VERIFICA QUE EL TIPO DE ENTRADA EN CADA CAMPO SEA CORRECTO
-(void)KeyProcessingWithArrayPK:(NSMutableArray *)ArrayPk FieldTag:(NSInteger )tag NumRows:(NSInteger)numRows
{
    NSInteger yCol = ((tag) / numRows);
    [KeyTimerProcesing invalidate];  // Invalida el temporizador que estuvo corriendo anteriormente
    
    NSString *tagString = [NSString stringWithFormat:@"%i",(int)tag];
    NSString *PrimaryKey;
    
    if ([[ArrayPk objectAtIndex:yCol] isEqualToString:@"Numeric"] || [[ArrayPk objectAtIndex:yCol] isEqualToString:@"PrimaryKeyN"]) {
        
        PrimaryKey = @"Numeric";
    }
    else if ([[ArrayPk objectAtIndex:yCol] isEqualToString:@"Alphabetic"] || [[ArrayPk objectAtIndex:yCol] isEqualToString:@"PrimaryKeyA"])
    {
        PrimaryKey = @"Alphabetic";
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:tagString,@"Tag",PrimaryKey,@"PrimaryKey", nil];
    
    KeyTimerProcesing = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(processKeyFielWithTag:) userInfo:dic repeats:YES];
}
-(void)processKeyFielWithTag:(NSTimer *)tagByTimer
{
    NSString *tag = [[tagByTimer userInfo] objectForKey:@"Tag"];
    NSString *PK = [[tagByTimer userInfo] objectForKey:@"PrimaryKey"];
    
    KeyVerified = [self getTextForFieldInTag:tag.intValue];
    NSNumberFormatter *Number = [[NSNumberFormatter alloc] init];
    
    if ([PK isEqualToString:@"Numeric"]) {
        
        BOOL isNumeric = [Number numberFromString:KeyVerified] != nil;
        
        if (isNumeric == NO && KeyVerified.length > 0) {
            
            [self writeInField:[KeyVerified substringToIndex:[KeyVerified length] -1] WithTag:tag.intValue];
        }
    }
    else if ([PK isEqualToString:@"Alphabetic"])
    {
        BOOL isNumeric = [Number numberFromString:KeyVerified] != nil;
        
        if (isNumeric == YES && KeyVerified.length > 0) {
            
           // [self writeInField:[KeyVerified substringToIndex:[KeyVerified length] -1] WithTag:tag.intValue];
        }
    }
}
// REVISAR : borrar el campo repetido cuando se hace dissmis al teclado
# pragma PRIMARY KEY
-(void)setUpPrimaryKeyInFieldsWithTag:(NSInteger )tag NumOfRows:(NSInteger )numRows ByArrayPrimaryKeyStatement:(NSMutableArray *)ArrayPK
{
    NSInteger yCol = ((tag) / numRows);
    [KeyTimerProcesing2 invalidate];  // Invalida el temporizador que estuvo corriendo anteriormente
    
    if ([[ArrayPK objectAtIndex:yCol] isEqualToString:@"PrimaryKey"]) {
        
        processPrimaryKey = YES;
        
        NSInteger pkTag = (yCol * numRows);  // obtiene el tag de el primer campo de la columna que utiliza PrimaryKey
        NSInteger limitTag = ((yCol + 1) * numRows);  // Indica limite que llegara durante el recorrido. Obtiene la cantidad de filas en la columna seleccionada.
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%i",(int)pkTag],@"startTag",[NSString stringWithFormat:@"%i",(int)limitTag],@"limitTag",[NSString stringWithFormat:@"%i",(int)tag],@"tagSelected", nil];
        
        KeyTimerProcesing2 = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(processingPrimaryKey) userInfo:dic repeats:YES];
        
    }
    else if ([[ArrayPK objectAtIndex:yCol] isEqualToString:@"PrimaryKeyN"] || [[ArrayPK objectAtIndex:yCol] isEqualToString:@"PrimaryKeyA"])
    {   // Permite que se introduzcan los datos dependiendo del tipo definido al campo. Si es numerico ademas de primaryKey, procesara los datos introducidos para asegurar el dato de tipo numerico
        
        processPrimaryKey = YES;
        
        NSInteger pkTag = (yCol * numRows);  // obtiene el tag de el primer campo de la columna que utiliza PrimaryKey
        NSInteger limitTag = ((yCol + 1) * numRows);  // Indica limite que llegara durante el recorrido. Obtiene la cantidad de filas en la columna seleccionada.
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%i",(int)pkTag],@"startTag",[NSString stringWithFormat:@"%i",(int)limitTag],@"limitTag",[NSString stringWithFormat:@"%i",(int)tag],@"tagSelected", nil];
        
        KeyTimerProcesing2 = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(processingPrimaryKey) userInfo:dic repeats:YES];
    }
}
-(void)processingPrimaryKey
{
    if (processPrimaryKey == YES) {
    
        processPrimaryKey = NO;
        
        NSInteger pkTag = [[[KeyTimerProcesing2 userInfo] objectForKey:@"startTag"] intValue];
        NSInteger limitTag = [[[KeyTimerProcesing2 userInfo] objectForKey:@"limitTag"] intValue];
        NSInteger tag = [[[KeyTimerProcesing2 userInfo] objectForKey:@"tagSelected"] intValue];
            
    for (NSInteger i = pkTag; i <= limitTag; i++) {
        
        if (i == tag) {
            continue;
        }
        if (i < (limitTag)) {
           processPrimaryKey = YES;
        
        if ([[self getTextForFieldInTag:tag] isEqualToString:[self getTextForFieldInTag:i]] && [[self getTextForFieldInTag:tag] length] > 0) {
            
            [self writeInField:@"" WithTag:tag];
            [self createAlertWithTitle:@"Information" Message:@"Already exist this data." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
            
        }}
    }}
}

#pragma ENVIA POR CORREO LOS DATOS DE LA TABLA
-(void)shareTableWithContentODXFromArray:(NSMutableArray *)arrayContentODX ArrayWithFields:(NSMutableArray *)arrayField TableName:(NSString *)tableName NumberOfRows:(NSInteger) numRows ButIfContentIsFromCSV:(NSString *)CSVContent ConditionDataTypeCSVODX:(NSString *)conditionDataType
{
    NSString *fieldMessage;
    NSString *Body;
    NSString *message = @"";
    NSString *repMessage = @"";
    NSString *fieldName = @"";
    NSString *repFieldName = @"";
    
    if ([conditionDataType isEqualToString:@"ODX"]) {
        
    for (int i = 0; i < [arrayContentODX count]; i++) {
        
        message = [repMessage stringByAppendingString:[NSString stringWithFormat:@"%@,",[arrayContentODX objectAtIndex:i]]];
        repMessage = message;
    }
    
    for (int i = 0; i < [arrayField count]; i++) {
        
        fieldName = [repFieldName stringByAppendingString:[NSString stringWithFormat:@"'%@',",[arrayField objectAtIndex:i]]];
        repFieldName = fieldName;
    }
    
    fieldMessage = [NSString stringWithFormat:@"Onedtx, the best way to manage your business data. \n\n Table name: %@ \n\n To import this table in another or the same device you must first create the table with the following characteristics: \n\n *Create the fields with the names: %@ \n *Number of rows: %i \n *Finally, copy the table code.",tempTBname,fieldName,(int)numRows];
    
    Body = [NSString stringWithFormat:@"%@ \n\nHelp: %@\n\n*** ODX table code: ***\n\n%@",fieldMessage,HELP_URL,message];
    }
    else if ([conditionDataType isEqualToString:@"CSV"])
    {
        for (int i = 0; i < [arrayField count]; i++) {
            
            fieldName = [repFieldName stringByAppendingString:[NSString stringWithFormat:@"'%@',",[arrayField objectAtIndex:i]]];
            repFieldName = fieldName;
        }
        
        fieldMessage = [NSString stringWithFormat:@"Onedtx, the best way to manage your business data. \n\n Table name: %@ \n\n To import this table in another or the same device you must first create the table with the following characteristics: \n\n *Create the fields with the names: %@ \n *Number of rows: %i \n *Finally, copy the table code.",tempTBname,fieldName,(int)numRows];
        
        Body = [NSString stringWithFormat:@"%@ \n\nHelp: %@\n\n*** CSV table code: ***\n\n%@",fieldMessage,HELP_URL,CSVContent];
    }
    
    MFMailComposeViewController *compose = [[MFMailComposeViewController alloc] init];
    [compose setDelegate:self];
    [compose setTitle:tableName];
    [compose setSubject:[NSString stringWithFormat:@"%@/%@",tempDBname,tempTBname]];
    [compose setMessageBody:Body isHTML:NO];
    [compose setEditing:NO];
    [compose setMailComposeDelegate:self];
    [self presentViewController:compose animated:YES completion:NULL];
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result) {
        
        [self createAlertWithTitle:@"Information" Message:@"Your table was sent successfully, please visit your E-mail for more information." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
    }
    else if (error)
    {
        [self createAlertWithTitle:@"Information" Message:@"Your table cannot be sent, please try again later." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

# pragma CONVIERTE LOS DATOS DE UNA TABLA TXT Y LOS ALMACENA EN UN ARRAY
-(NSMutableArray *)setArrayTableWithContentFromTxt:(NSString *)tableContent  // Recibe el contenido de la tabla en forma de texto (enviada por correo) y lo almacena en un array, el cual, permitira establecer el valor a cada campo.
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    
    char charecter;
    NSString *tableData = @"";
    NSString *repTableData = @"";
    
    for (int i = 0; i < [tableContent length]; i++) {
        
        charecter = [tableContent characterAtIndex:i];
       
        if ([[NSString stringWithFormat:@"%c",charecter] isEqualToString:@","]) {
        
            [array addObject:tableData];
            tableData = @"";
            repTableData = @"";
            
            continue;
        }
        
        tableData = [repTableData stringByAppendingString:[NSString stringWithFormat:@"%c",charecter]];
        repTableData = tableData;
    }
    return array;
}

# pragma EXPORTA LOS DATOS DE LA TABLA EN FORMATO SQL (.CSV)
-(NSString *)exportDataFromTableContentToSQL:(NSMutableArray *)arrayContent ArrayAmountOBFields:(NSMutableArray *)arrayAmount NumRows:(NSInteger)numRows // Convierte el contenido de la tabla en formato entendible por MySql (datos linea por linea separada por coma)
{
    NSString *RESULT;
    NSString *data = @"";
    NSString *repData = @"";
    NSNumberFormatter *Number = [[NSNumberFormatter alloc] init];
    
        [self convertInCoordinatesFromTag:([arrayAmount count] -1) numRows:numRows];  // Obtiene la cantidad de campos (nombre de campos) y filas que tiene hay en la tabla. coorYcol contiene la cantidad de campos en la tabla, coorXRows contiene la cantidad de filas en la tabla
    
        for (int a = 0; a < coorXrow; a++) {  // Lineas de la tabla
            
            for (int b = 1; b <= coorYcol; b++) {  // Campos de la tabla
                
                BOOL isNumeric = [Number numberFromString:[NSString stringWithFormat:@"%@",[arrayContent objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:b NumRows:numRows]]]] != nil;
                
                if (isNumeric == YES) { // Campo numerico
                    
                    data = [repData stringByAppendingString:[NSString stringWithFormat:@"%@,",[arrayContent objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:b NumRows:numRows]]]];
                }
                else  // Alfanumerico
                {
                data = [repData stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[arrayContent objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:b NumRows:numRows]]]];
                }
                
                repData = data;
            }
            
            data = [repData substringToIndex:[repData length] - 1]; // Borra el ultimo caracter de el string (,)
            repData = [data stringByAppendingString:@"\n"];
            
            RESULT = data;
        }
    
    return  RESULT;
}

# pragma IMPORTA LOS DATOS SQL DE UNA TABLA (.CSV)
-(void)importTableContentFromSQLData:(NSString *)SqlContent InjectDataInArray:(NSMutableArray *)arrayData
{
    [arrayData removeAllObjects];  // Borrando array que posee los contenido de la tabla (arrayDataField).
    
    char schar;
    bool isQuotes = NO;  // Identifica cuando es la primera comilla o la ultima del string. La primera comilla se encuentra en la posicion 0 del string (hace el booleano verdadero), la segunda se encuentra al final del string del campo (hace el booleano falso). Luego la sigte comilla despues de la coma que separa los string de cada campo (hace el booleano verdadero)
    NSNumberFormatter *number = [[NSNumberFormatter alloc] init];
    NSInteger numRows = 1;
    NSInteger numFields = 1;
    bool canCountFields = YES;
    
    [arrayData addObject:@""]; // Deja un espacio para cada campo
    
    for (int i = 0; i < [SqlContent length]; i++) {
        
        schar = [SqlContent characterAtIndex:i];
        
        if ([[NSString stringWithFormat:@"%c",schar] isEqualToString:@"."] || [[NSString stringWithFormat:@"%c",schar] isEqualToString:@"-"] || [[NSString stringWithFormat:@"%c",schar] isEqualToString:@"*"] || [[NSString stringWithFormat:@"%c",schar] isEqualToString:@"/"]) {
            
            continue;
        }
        
        bool isCharNumeric = [number numberFromString:[NSString stringWithFormat:@"%c",schar]] != nil;
        
        if ([[NSString stringWithFormat:@"%c",schar] isEqualToString:@"\""] && isQuotes == NO) { // Encuentra la primera comilla del string del campo.
            isQuotes = YES;
            continue;
        }
        else if ([[NSString stringWithFormat:@"%c",schar] isEqualToString:@"\""] && isQuotes == YES)  // Encuentra la ultima comilla del string del campo.
        {
            isQuotes = NO;
            continue;
        }
        
        if (isQuotes == NO && ![[NSString stringWithFormat:@"%c",schar] isEqualToString:@","] && isCharNumeric == NO) { // Verifica que despues de la ultima comilla del string del campo no haya una coma, si no la hay entonces es el final de la linea (1...x) del archivo CSV. indicara el numero de lineas que contiene la tabla
            
            // numero de lineas de la tabla
            [arrayData addObject:@""]; // El ultimo campo de la linea no contiene coma. Guarda un espacio para el campo
            numRows ++;  // Indica cuantas lineas tiene la tabla
            canCountFields = NO;
            continue;
        }
        else if (isQuotes == NO && [[NSString stringWithFormat:@"%c",schar] isEqualToString:@","]) // Verifica que haya una coma despues de la ultima comilla del string del campo, si la hay guardara un string en el array de datos (habran tantos string en el array como campos en la tabla).
        {
            [arrayData addObject:@""]; // Deja un espacio para cada campo
            if (canCountFields == YES) {
                numFields++;
            }
        }
        else if (isCharNumeric == YES && [[NSString stringWithFormat:@"%c",schar] isEqualToString:@""])  // Indica el final de la linea del archivo CSV. EL campo es numerico.
        {
            [arrayData addObject:@""]; // Deja un espacio para cada campo (numerico)
            numRows ++;  // Indica cuantas lineas tiene la tabla
            continue;
        }
        else if (isCharNumeric == YES && [[NSString stringWithFormat:@"%c",schar] isEqualToString:@","]) //  EL campo es numerico.
        {
            [arrayData addObject:@""]; // El ultimo campo de la linea no contiene coma. Guarda un espacio para el campo
        }
    }
        
    
    [self injectingDataFromCSVFile:SqlContent NumFields:numFields numRows:numRows ArrayDataField:arrayData];
}
-(void)injectingDataFromCSVFile:(NSString *)SqlContent NumFields:(NSInteger )numfields numRows:(NSInteger )numRows ArrayDataField:(NSMutableArray *)arrayDataField
{
    char schar;
    NSString *data = @"";
    NSString *repData = @"";
    NSInteger R = 0;
    NSInteger F = 1;
    NSNumberFormatter *number = [[NSNumberFormatter alloc] init];
    bool isQuotes = NO;
    
    for (int i = 0; i < [SqlContent length]; i++) {
        
        schar = [SqlContent characterAtIndex:i];
        
        if ([[NSString stringWithFormat:@"%c",schar] isEqualToString:@"."] || [[NSString stringWithFormat:@"%c",schar] isEqualToString:@"-"] || [[NSString stringWithFormat:@"%c",schar] isEqualToString:@"*"] || [[NSString stringWithFormat:@"%c",schar] isEqualToString:@"/"]) {
            
            data = [repData stringByAppendingString:[NSString stringWithFormat:@"%c",schar]];
            repData = data;
            continue;
        }
        
        bool isCharNumeric = [number numberFromString:[NSString stringWithFormat:@"%c",schar]] != nil;
        
        
        if ([[NSString stringWithFormat:@"%c",schar] isEqualToString:@"\""] && isQuotes == NO) { // Encuentra la primera comilla del string del campo.
            isQuotes = YES;
            continue;
        }
        else if ([[NSString stringWithFormat:@"%c",schar] isEqualToString:@"\""] && isQuotes == YES)  // Encuentra la ultima comilla del string del campo.
        {
            isQuotes = NO;
            continue;
        }
        
        if (isQuotes == YES || isCharNumeric == YES) {  // Escribe todo excepto las comillas, las comas y los espacios nulos(indican \n)
            
            data = [repData stringByAppendingString:[NSString stringWithFormat:@"%c",schar]];
            repData = data;
        }
        
        if (isQuotes == NO && ![[NSString stringWithFormat:@"%c",schar] isEqualToString:@","] && isCharNumeric == NO) { // Verifica que despues de la ultima comilla del string del campo no haya una coma, si no la hay entonces es el final de la linea (1...x) del archivo CSV. indicara el numero de lineas que contiene la tabla
            
            [arrayDataField replaceObjectAtIndex:[self convertToTagFromCoordinateXrow:R Ycol:F NumRows:numRows] withObject:data];
            data = @"";
            repData = @"";
            R++;
            F = 1;
            continue;
        }
        else if (isQuotes == NO && [[NSString stringWithFormat:@"%c",schar] isEqualToString:@","]) // Verifica que haya una coma despues de la ultima comilla del string del campo, si la hay guardara un string en el array de datos (habran tantos string en el array como campos en la tabla).
        {
            [arrayDataField replaceObjectAtIndex:[self convertToTagFromCoordinateXrow:R Ycol:F NumRows:numRows] withObject:data];
            data = @"";
            repData = @"";
            F++;
        }
        else if (isCharNumeric == YES && [[NSString stringWithFormat:@"%c",schar] isEqualToString:@""])  // Indica el final de la linea (\n) de un campo numerico.
        {
            [arrayDataField replaceObjectAtIndex:[self convertToTagFromCoordinateXrow:R Ycol:F NumRows:numRows] withObject:data];
            data = @"";
            repData = @"";
            R ++;  // Indica cuantas lineas tiene la tabla
            continue;
        }
        else if (isCharNumeric == YES && [[NSString stringWithFormat:@"%c",schar] isEqualToString:@","]) // indica el final de un campo numerico.
        {
            [arrayDataField replaceObjectAtIndex:[self convertToTagFromCoordinateXrow:R Ycol:F NumRows:numRows] withObject:data]; // El ultimo campo de la linea no contiene coma. Guarda un espacio para el campo
            data = @"";
            repData = @"";
            F++;
        }
    }
    
    [arrayDataField replaceObjectAtIndex:[self convertToTagFromCoordinateXrow:(numRows - 1) Ycol:numfields NumRows:numRows] withObject:data]; // Guardando el ultimo valor del campo de la tabla.
    data = @"";
    repData = @"";
}

# pragma VERIFICA EL ESTADO DE ACUERDO DEL CONTRATO
-(void)verifyContractAgreementStatus
{
    if ([self contractAgreementMethod:@"GET" IfitsPOSTsetChoiseOfContract:nil] == NO) { // Contrato no acordado
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contract agreement" message:@"You should read the policy and terms of use." delegate:self cancelButtonTitle:@"Policy and terms of use" otherButtonTitles:nil, nil];
        [alert setTag:4];
        [alert show];
    }
}

# pragma BUSCA CAMBIO EN EL CONTRACTO.
-(void)processingContract  // El webview accede a la direccion donde se encuentra la configuracion del contracto. la configuracion se verifica segun el incremento del numeros de contrato. Si el numero de contrato es mayor que el numero del contrato anterior, entonces, hay un nuevo contrato y el usuario debera aceptarlo para seguir usando la app. Se verifica la configuracion del contrato en vez de la informacion del mismo para facilitar obtencion de los cambios en el contrato: (la conguracion tiene menos caracteres que la info del contrato)
{
    configContractWebView = [[UIWebView alloc] init];  
    [configContractWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:remote_Setting]]];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    contractNumber = [[userDefault objectForKey:@"contractNumber"] integerValue];
    NSLog(@"CN %i",(int)contractNumber);
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkNewChangesInContract) userInfo:nil repeats:YES]; // Obtiene el numero del contrato.
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(reloadContract) userInfo:nil repeats:YES];  // Actualiza la paguina para asegurar el cambio en el contrato. cuando se actualiza la paguina el numero del contrato es 0.
    
    [self verifyContractAgreementStatus];
}
-(void)checkNewChangesInContract
{
    NSLog(@"contract: %i",(int)[self getContractNumber:[configContractWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerText"]]);
    
    if (contractNumber < [self getContractNumber:[configContractWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerText"]]) {
        
        contractNumber = [self getContractNumber:[configContractWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerText"]];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:[NSString stringWithFormat:@"%i",(int)contractNumber] forKey:@"contractNumber"];
        [userDefault synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissIfisNeeded" object:nil];  // notifica al viewController (legal) que haga dismiss si esta activo. Evita que se provoque un error al aceptar la alerta que invoca la clase (legal).
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contract updated" message:@"The contract has been updated, please read the news term of use." delegate:self cancelButtonTitle:@"Accept" otherButtonTitles:nil, nil];
        [alert setTag:4];
        [alert show];
        
        [self contractAgreementMethod:@"POST" IfitsPOSTsetChoiseOfContract:@"NO"];  // Cuando el contrato se modifica tambien se modifica la configuracion remota del contrato, una vez que encuentre un nuevo contrato se deshacera del anterior (borrara el acuerdo) y requerira la aceptacion del nuevo contrato.
     }
}
-(void)reloadContract
{
    [configContractWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:remote_Setting]]];
}
-(NSInteger)getContractNumber:(NSString *)setting
{
    NSInteger RESULT = 0;
    NSString *data = @"";
    NSString *repData = @"";
    BOOL copy = NO;
    
    for (int i = 0; i < [setting length]; i++) {
        
        if ([[NSString stringWithFormat:@"%c",[setting characterAtIndex:i]] isEqualToString:@"("]) {
            
            copy = YES;
            continue;
        }
        else if ([[NSString stringWithFormat:@"%c",[setting characterAtIndex:i]] isEqualToString:@")"])
        {
            copy = NO;
            break;
        }
        
        if (copy == YES) {
            
            data = [repData stringByAppendingString:[NSString stringWithFormat:@"%c",[setting characterAtIndex:i]]];
            repData = data;
        }
    }
    RESULT = [data intValue];
    return RESULT;
}

# pragma GUARDA O CARGA LA INFORMACION DEL ACUERDO
-(BOOL)contractAgreementMethod:(NSString *)method IfitsPOSTsetChoiseOfContract:(NSString *)choiseContract // Esta funcion exige un metodo que identifica el tipo de tarea que ejecutara, los metodos son GET (obtiene en booleano que indica si esta aceptado o no el acuerdo) y POST (permite establecer el acuerdo del contrato).
{
    BOOL RESULT;
    
    if ([method isEqualToString:@"GET"]) {
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *string = [userDefault objectForKey:@"isContractAgreed"];
        
        if ([string isEqualToString:@"YES"]) {
            RESULT = YES;
        }
        else
        {
            RESULT = NO;
        }}
    else if ([method isEqualToString:@"POST"])
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:choiseContract forKey:@"isContractAgreed"];
        [userDefault synchronize];
    }
    
    return RESULT;
}

#pragma CREA MENSAJES DE ALERTAS
-(void)createAlertWithTitle:(NSString *)title Message:(NSString *)message CancelBtnTitle:(NSString *)cancelBtnTitle OtherBtnTitle:(NSString *)otherBtnTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelBtnTitle otherButtonTitles:otherBtnTitle, nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {  // EXPORT BUTTON

    if (buttonIndex == 1) {  // CSV file
        
        // antes usaba (arrayDataField), ahora toma los datos directamente de los campos para mayor presicion.
        [self shareTableWithContentODXFromArray:nil ArrayWithFields:arrayFieldNames TableName:tempTBname NumberOfRows:numOfColField ButIfContentIsFromCSV:[self exportDataFromTableContentToSQL:arrayDataField ArrayAmountOBFields:arrayDataField NumRows:([arrayDataField count] / [arrayFieldNames count])] ConditionDataTypeCSVODX:@"CSV"];
    }
    else if (buttonIndex == 2)  // onedtx file
    {
        [self shareTableWithContentODXFromArray:arrayDataField ArrayWithFields:arrayFieldNames TableName:tempTBname NumberOfRows:numOfColField ButIfContentIsFromCSV:nil ConditionDataTypeCSVODX:@"ODX"];
    }}
    else if (alertView.tag == 2) // LOAD TABLE FROM: IMPORT
    {
        
        if (buttonIndex == 1) // CSV file
        {
            TxtLoader.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:TxtLoader animated:YES completion:NULL];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"createViewCSVLoader" object:nil];
        }
        else
        if (buttonIndex == 2) { // TXT file
            
            TxtLoader.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:TxtLoader animated:YES completion:NULL];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"createViewTXTLoader" object:nil];
        }
    }
    else if (alertView.tag == 3)  // Borrando tabla o base de datos
    {
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.3];
        [delete setFrame:CGRectMake(12, 12, 0, 0)];
        [edit setFrame:CGRectMake(2, 35, 0, 0)];
        [enterInConsole setFrame:CGRectMake(2, 35, 0, 0)];
        [UIView commitAnimations];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(removeDeleteButton) userInfo:nil repeats:NO];
        
        if (buttonIndex == 1) {  // boton (YES)
            
            if (scrollDataBase.alpha == 1.0) {  // Borrando base de datos
                
                [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,tempDBname] error:nil];
                [self removeScrollDataBase];
                [self verifyAppDirectory];
            }
            else if (scrollTables.alpha == 1.0) // Borrando tablas
            {
                if ([[self lookForTableKeyAtDBPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,tempDBname] WithTableName:tempTBname Funtion:@"GET" ForCasePOSTSetTheReferenceQuestion:nil Password:nil] count] == 0) {  // Busca en la carpeta de contrasenas de la base de datos, Si no se encontro ningun archivo (nombretabla.pass) el tamano del array sera 0 indicando que la tabla no posee contrasena.
                    
                    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@/%@",oneDataDirPath,tempDBname,tempTBname] error:nil];
                    
                    [self removeScrollTables];
                    arrayTables = [self getTableNamesFromDataBaseName:tempDBname RootPath:oneDataDirPath];   // Cargando el array con las tablas de la DB
                    
                    [self createTBviewsWithNameFromArray:[self getTableNamesFromDataBaseName:tempDBname RootPath:oneDataDirPath] WithWidth:200 AndHeight:180 SpaceSize:30 InPlace:CGRectMake(25, 90, MainDBView.frame.size.width - 25, MainDBView.frame.size.height - 90) InView:MainDBView Alpha:1.0];
                }
                else  // El tamano del array es mayor que 0. (indica que la tabla posee contrasena)
                {
                    [self passwordAlert];
                }
            }}
    }
    else if (alertView.tag == 4) // New contract
    {
        Legal.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:Legal animated:YES completion:NULL];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:Policy_And_TermsOfUse,@"terms", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"New Contract" object:self userInfo:dic];
    }
    else if (alertView.tag == 5) // Boton edit: permite cambiar el nombre de la DB, hacerle backup y ver la informacion de la misma
    {
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.3];
        [delete setFrame:CGRectMake(12, 12, 0, 0)];
        [edit setFrame:CGRectMake(2, 35, 0, 0)];
        [enterInConsole setFrame:CGRectMake(2, 35, 0, 0)];
        [UIView commitAnimations];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(removeDeleteButton) userInfo:nil repeats:NO];
        
        if (buttonIndex == 1) { // Rename data base: permite cambiar el nombre de la base de datos
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(renameDataBaseAlert) userInfo:nil repeats:NO];
        }
        else if (buttonIndex == 2)  // backup: le hace una copia de seguridad a la base de datos seleccionada
        {
            NSString *backupDBName = [NSString stringWithFormat:@"BACKUP-->%@",tempDBname];
            
            [UIView beginAnimations:NULL context:NULL];
            [UIView setAnimationDuration:0.3];
            [delete setFrame:CGRectMake(12, 12, 0, 0)];
            [edit setFrame:CGRectMake(2, 35, 0, 0)];
            [enterInConsole setFrame:CGRectMake(2, 35, 0, 0)];
            [UIView commitAnimations];
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(removeDeleteButton) userInfo:nil repeats:NO];
            
            [self editDataBaseName:tempDBname AtPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,tempDBname] WithName:backupDBName RootPath:oneDataDirPath Funtion:@"Backup"];
            [self removeScrollDataBase];
            [self verifyAppDirectory];
        }
    }
    else if (alertView.tag == 6)  // Edit db. Cambia el nombre de la base de datos (Rename data base). Cuando el usuario presiona el boton renombrar, un timer invoca un alertView con tag = 6 que permite introducir el nombre de la base de datos
    {
        if (buttonIndex == 1) {
       
            NSString *newDBName = [[alertView textFieldAtIndex:0] text];
            
            BOOL Continue = NO;
            for (int i = 0; i < [newDBName length]; i++) {
                
                if (![[NSString stringWithFormat:@"%c",[newDBName characterAtIndex:i]] isEqualToString:@" "]) { Continue = YES; } else { Continue = NO; [self createAlertWithTitle:@"Information" Message:@"The database name can not have spaces." CancelBtnTitle:@"Accept" OtherBtnTitle:nil]; break; }
            }
            
            if (Continue == YES) {
            
            [UIView beginAnimations:NULL context:NULL];
            [UIView setAnimationDuration:0.3];
            [delete setFrame:CGRectMake(12, 12, 0, 0)];
            [edit setFrame:CGRectMake(2, 35, 0, 0)];
            [enterInConsole setFrame:CGRectMake(2, 35, 0, 0)];
            [UIView commitAnimations];
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(removeDeleteButton) userInfo:nil repeats:NO];
            
        [self editDataBaseName:tempDBname AtPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,tempDBname] WithName:newDBName RootPath:oneDataDirPath Funtion:@"Rename"];
            [self removeScrollDataBase];
            [self verifyAppDirectory];
            }
        }
    }
    else if (alertView.tag == 7) // Remove sheet
    {
        if (buttonIndex == 1) {
            
        [self eraseSheetAtPath:SheetPath];
        }
    }
    else if (alertView.tag == 8)  // Password
    {
        if (buttonIndex == 1) {
            
            NSString *enteredPass = [[alertView textFieldAtIndex:0] text];
            NSString *password = [[self lookForTableKeyAtDBPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,tempDBname] WithTableName:tempTBname Funtion:@"GET" ForCasePOSTSetTheReferenceQuestion:nil Password:nil] objectAtIndex:1];
            
            if ([enteredPass isEqualToString: password]) {
                
                if (([ModeGraphORConsol isEqualToString:graphicsTableMode] || [ModeGraphORConsol isEqualToString:consoleTableMode])) {
            
                [self allocTableWithDataBaseName:tempDBname AtPath:[NSString stringWithFormat:@"%@/%@/%@",oneDataDirPath,tempDBname,tempTBname] FUNTION:@"CREATE" MODE:ModeGraphORConsol];  // Cargando tabla de la DB y TB seleccionadas. (FUNTION: indica si creara o actualizara la tabla)
                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                
                [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(removeScrollTables) userInfo:nil repeats:NO];
                [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(removeScrollDataBase) userInfo:nil repeats:NO];
                
                [UIView beginAnimations:NULL context:NULL];
                [UIView setAnimationDuration:0.3];
                [newTB setAlpha:0.0];   // nueva tabla
                [backToDataBase setAlpha:0.0];   // volver
                [viewTableContainer setFrame:CGRectMake(0, 0, 1024, 768)];
                [UIView commitAnimations];
                
                [UIView beginAnimations:NULL context:NULL]; // View principal
                [UIView setAnimationDuration:0.6];
                [MainView setFrame:CGRectMake(-200, 0, 1024, 768)];
                [UIView commitAnimations];
                    
                }
                else if ([ModeGraphORConsol isEqualToString:externConsultTableMode]) // Consulta externa
                {
                    if ([[queryDictionary objectForKey:@"sentence"] isEqualToString:@"select"]) {
                 
                        [self makeConsulteInTable:[queryDictionary objectForKey:@"tableName"] Ofdatabase:tempDBname Fields:[queryDictionary objectForKey:@"fields"] FieldCondition:[queryDictionary objectForKey:@"conditionalField"] CondOperator:[queryDictionary objectForKey:@"condOperator"] ConditionValue:[queryDictionary objectForKey:@"condValue"] ThenPlaceItinView:externConsultView WithFrame:CGRectMake(0, externConsultView.frame.size.height - 350, externConsultView.frame.size.width, 350) UsingCurrentData:NO Animation:YES];
                    }
                    else if ([[queryDictionary objectForKey:@"sentence"] isEqualToString:@"delete"])
                    {
                        [self deleteFromTable:[queryDictionary objectForKey:@"tableName"] ConditionalField:[queryDictionary objectForKey:@"conditionalField"] ConditionalOperator:[queryDictionary objectForKey:@"condOperator"] ConditionalValue:[queryDictionary objectForKey:@"condValue"]];
                    }
                    else if ([[queryDictionary objectForKey:@"sentence"] isEqualToString:@"update"])
                    {
                        [self updateTable:[queryDictionary objectForKey:@"tableName"] SETSingleField:[queryDictionary objectForKey:@"singleField"] SingleOperator:[queryDictionary objectForKey:@"singleFieldOperator"] SingleValue:[queryDictionary objectForKey:@"singleFieldValue"] WHEREConditionalField:[queryDictionary objectForKey:@"conditionalField"] ConditionalOperator:[queryDictionary objectForKey:@"condOperator"] ConditionalValue:[queryDictionary objectForKey:@"condValue"]];
                    }
                    else if ([[queryDictionary objectForKey:@"sentence"] isEqualToString:@"insertinto"])
                    {
                        [self insertIntoTable:[queryDictionary objectForKey:@"tableName"] InFields:[queryDictionary objectForKey:@"fields"] Values:[queryDictionary objectForKey:@"values"] Database:tempDBname];
                    }
                    else if (insertAssistantView.superview)
                    {
                        [self nextAssistantButtonAction];
                    }
                }

            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not match" message:@"The password you entered is wrong" delegate:self cancelButtonTitle:@"Accept" otherButtonTitles:@"Try again", nil];
                [alert setTag:9];
                [alert show];
            }
        }
  
    }
    else if (alertView.tag == 9)
    {
        if (buttonIndex == 1) {
            
            [self passwordAlert];
        }
    }
    else if (alertView.tag == 10)  // Edit field name (NOMBRE ACTUAL)
    {
        if (buttonIndex == 1) {
       
        NSString *olderFieldName = [[alertView textFieldAtIndex:0] text];
        
        if (![olderFieldName isEqualToString:@""] && ![olderFieldName isEqualToString:@" "]) {
            
        for (int i = 0; i < [arrayFieldNames count]; i++) {
            
            if ([olderFieldName isEqualToString:[arrayFieldNames objectAtIndex:i]]) {
                
                // Mostrar el segundo mensaje (insertar el nuevo nombre del campo)
                indexArrayFieldName = (int)i;
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit field name" message:@"Insert the new name that will own the field." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Apply", nil];
                [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                [alert setTag:11];
                [alert show];
                break;
            }
            else
            {
                indexArrayFieldName = -1; // evita errores
            }
        }}
            if (indexArrayFieldName == -1) { // No encontro el nombre del campo
                
                [self createAlertWithTitle:@"Not match" Message:@"The field does not exist in the table." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
            }
        }
    }
    else if (alertView.tag == 11) // Edit field name (NUEVO NOMBRE)
    {
        if (buttonIndex == 1) {
        
        NSString *newFieldName = [[alertView textFieldAtIndex:0] text];
        
        if (indexArrayFieldName != -1) {
          
            [arrayFieldNames replaceObjectAtIndex:indexArrayFieldName withObject:newFieldName]; // remplazando el nombre anterior del campo con el nuevo
            indexArrayFieldName = 0;
            
            [self autoSavingDataBase];
            [self updateTableWithNewFields];
            }
        }
    }
    else if (alertView.tag == 12)  // Set password: (El usuario desea cambiar la contrasena de la tabla)
    {
        if (buttonIndex == 1) { // Estan validas las condiciones para guardar la contrasena (no refWordtxt y passTxt NULOS)
            
            UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Please, type your current password to confirm." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Apply", nil];
            [Alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [Alert setTag:13];
            [Alert show];
        }
    }
    else if (alertView.tag == 13) // Comfirm password (set new pass)
    {
        if (buttonIndex == 1) {
            
            NSString *pass = [[alertView textFieldAtIndex:0] text];
            
            if ([pass isEqualToString:[[self lookForTableKeyAtDBPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,tempDBname] WithTableName:tempTBname Funtion:@"GET" ForCasePOSTSetTheReferenceQuestion:nil Password:nil] objectAtIndex:1]]) {  // la contrasena insertada es igual a la guardada
        
                [self lookForTableKeyAtDBPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,tempDBname] WithTableName:tempTBname Funtion:@"POST" ForCasePOSTSetTheReferenceQuestion:refWordTextField.text Password:passwordTextField.text];
                
                // contrasena guardada en la ruta de la base de datos donde se encuentra la tabla, en la carpeta (password) archivo: nombretabla.pass
            }
            else
            {
                [self createAlertWithTitle:@"Not match" Message:@"Password incorrect" CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
            }
        }
    }
    else if (alertView.tag  == 14)
    {
        if (buttonIndex == 1) {
            
            NSString *pass = [[alertView textFieldAtIndex:0] text];
            
            if ([pass isEqualToString:[[self lookForTableKeyAtDBPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,tempDBname] WithTableName:tempTBname Funtion:@"GET" ForCasePOSTSetTheReferenceQuestion:nil Password:nil] objectAtIndex:1]]) {  // la contrasena insertada es igual a la guardada
            
                [self unLockTable];
            }
            else
            {
                [self createAlertWithTitle:@"Not match" Message:@"Password incorrect" CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
            }
        }
    }
    else if (alertView.tag == 15) // Enter in mode console (Entra a la tabla en modo solo lectura)
    {
        if (buttonIndex == 1) {
            
            ModeGraphORConsol = consoleTableMode;
            [self invocateTableWithMode:consoleTableMode Tag:tablePressedTag];
            
        }
    }
    else if (alertView.tag == 16)  // Query history name
    {
        if (buttonIndex == 1) {
            
            NSString *queryHistoryName = [[alertView textFieldAtIndex:0] text];
            
            if (![queryHistoryName isEqualToString:@" "] || ![queryHistoryName isEqualToString:@""]) {
                
                [self saveQueryUsedRecentlyFromArrayRecentQueries:recentQuerys WithFileName:queryHistoryName];
            }
            else
            {
                [self createAlertWithTitle:@"Not match" Message:@"You have not entered the file name." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
            }
            
        }
    }
    else if (alertView.tag == 17) // Save queryResult With name
    {
        if (buttonIndex == 1) { // Save
            
            [self saveQueryResultWithFileName:[NSString stringWithFormat:@"%@ >> (%@)",[[alertView textFieldAtIndex:0] text],quertyTextField.text] QueryCommand:[NSString stringWithFormat:@"[%@/%@] -->> %@",tempDBname,tempTBname,quertyTextField.text] RootPath:oneDataDirPath ArrayResult:arraydataQueryResult ArrayFieldNames:arrayFieldNameQueryResult];
        }
    }
    else if (alertView.tag == 18)  // Existe un archivo .queryResult Con el mismo nombre. Cambia en nombre
    {
        if (buttonIndex == 1) {  // Change
            
            [self alertSetNameToQueryResultFile];
        }
    }
    else if (alertView.tag == 19) // Botton load (EXTERNCONSULT)
    {
        
        if (buttonIndex == 1 || buttonIndex == 2) {
            
            if (!backGrundLQHV.superview) {
                
                backGrundLQHV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, externConsultView.frame.size.width, externConsultView.frame.size.height)];
                [backGrundLQHV setBackgroundColor:[UIColor whiteColor]];
                [backGrundLQHV setAlpha:0.0];
                [externConsultView addSubview:backGrundLQHV];
                
                loadQueryHistoryView = [[UIView alloc] initWithFrame:CGRectMake(255, 180, 360, 250)];
                [loadQueryHistoryView setBackgroundColor:excelTableViewBGColor];
                loadQueryHistoryView.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
                loadQueryHistoryView.layer.borderWidth = 0.3;
                [loadQueryHistoryView setAlpha:0.0];
                [externConsultView addSubview:loadQueryHistoryView];
                
                UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, loadQueryHistoryView.frame.size.width, 35)];
                
                if (buttonIndex == 1) { // Load query history
                    
                    [title setText:@"HISTORY QUERY"];
                }
                else if (buttonIndex == 2)  // Load query Result
                {
                    [title setText:@"QUERY RESULTS"];
                }
                
                [title setTextAlignment:NSTextAlignmentCenter];
                [title setFont:HeitiTC_14];
                [title setTextColor:normalStateTableInternalBtnColor];
                [title setBackgroundColor:[UIColor whiteColor]];
                [loadQueryHistoryView addSubview:title];
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 35, loadQueryHistoryView.frame.size.width, 35)];
                [view setBackgroundColor:[UIColor whiteColor]];
                [loadQueryHistoryView addSubview:view];
              
                if (buttonIndex == 1) {
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
                    [label setText:@" From:"];
                    [label setTextAlignment:NSTextAlignmentLeft];
                    [label setFont:[UIFont fontWithName:@"Heiti TC" size:13]];
                    [label setTextColor:normalStateTableInternalBtnColor];
                    [view addSubview:label];
                
                    dbNameTxt = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, 150, 35)];
                    [dbNameTxt setPlaceholder:@"Database name"];
                    [dbNameTxt setTextAlignment:NSTextAlignmentLeft];
                    [dbNameTxt setFont:[UIFont fontWithName:@"Heiti TC" size:13]];
                    [dbNameTxt setText:useDatabaseTxt.text];
                    [view addSubview:dbNameTxt];
                }
                
                UIButton *refresh = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, 25, 25)];
                [refresh setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateNormal];
                
                if (buttonIndex == 1) { [refresh setTag:3]; }else if (buttonIndex == 2) { [refresh setTag:5]; }
                
                [refresh addTarget:self action:@selector(resingExternQueryViewButtonsPressed:) forControlEvents:UIControlEventTouchDown];
                [loadQueryHistoryView addSubview:refresh];
                
                UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(327, 9, 22, 22)];
                [close setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
                [close setTag:4];
                [close addTarget:self action:@selector(resingExternQueryViewButtonsPressed:) forControlEvents:UIControlEventTouchDown];
                [loadQueryHistoryView addSubview:close];
                
                [UIView beginAnimations:NULL context:NULL];
                [UIView setAnimationDuration:0.3];
                [loadQueryHistoryView setAlpha:1.0];
                [backGrundLQHV setAlpha:0.6];
                [UIView commitAnimations];
                
                if (buttonIndex == 1) { // Load query history
                    
                    [self processBuildingQueryHistoryLinkAndSetInView:loadQueryHistoryView]; // Construyendo los enlaces de los archivos (query) guardados
                }
                else if (buttonIndex == 2) // Load query results
                {
                    [self processBuildingQueryResultsLinkAndSetInView:loadQueryHistoryView]; // Construyendo los enlaces de los archivos (resultados de las consultas)
                }
            }
        }
        
    }
    
}

# pragma SENTENCIA SELECT
-(void)makeConsulteInTable:(NSString *)tableName Ofdatabase:(NSString *)database Fields:(NSMutableArray *)arrayFields FieldCondition:(NSString *)fieldCond CondOperator:(NSString *)condOperator ConditionValue:(id)value ThenPlaceItinView:(UIView *)view WithFrame:(CGRect)frame UsingCurrentData:(BOOL)usingCurrentData Animation:(BOOL)animate
{
    
    if ([ModeGraphORConsol isEqualToString:externConsultTableMode]) {  // Realizando la consulta desde la base de datos externa
    
        BOOL setArrayDataEqualToQueryResult = NO;
        
        // Usar los datos actuales: es usado cuando se ejecuta una consulta avanzada (desde el asistente), permite usar los mismos datos de la tabla; los mismos datos en arrayDataField
        
        if (usingCurrentData == NO) { // Consulta simple (sin el asistente). Cargara los datos de la tabla y luego realizara la consulta.
            
            [self allocTableWithDataBaseName:database AtPath:[NSString stringWithFormat:@"%@/%@/%@",oneDataDirPath,database,tableName] FUNTION:@"NONE" MODE:ModeGraphORConsol];  // Cargando los datos de la tabla.
            setArrayDataEqualToQueryResult = NO;
        }
        else if (usingCurrentData == YES) // Consulta avanzada (usando el asistente). Se sobreescribiran los datos del array de datos (arrayDataField) con el resultado de la consulta, la sigte consulta se realizara en base al resultado de la consulta anterior, guardada en arrayDataField...
        {
            setArrayDataEqualToQueryResult = YES; // permite hacer una copia del resultado de la consulta y guardarla en el arrayDataField
            
            if (numOfColField == 0) {
                
                [self allocTableWithDataBaseName:database AtPath:[NSString stringWithFormat:@"%@/%@/%@",oneDataDirPath,database,tableName] FUNTION:@"NONE" MODE:ModeGraphORConsol];
            }
        }
        
        // [ArrayField Count] equivale a numOfColField *[arrayFieldNames count]
        [self processConsulteInTable:tableName Fields:arrayFields FieldCondition:fieldCond CondOperator:condOperator ConditionValue:value ATBarrayDataField:arrayDataField ArrayFieldName:arrayFieldNames ArrayFieldCount:(numOfColField * [arrayFieldNames count]) NumRows:numOfColField ThenPlaceItinView:view WithFrame:frame Animation:NO Option_SetArrayDataFieldEqualToArrayResult:setArrayDataEqualToQueryResult];
    }
    else if ([ModeGraphORConsol isEqualToString:graphicsTableMode] && ([arrayField count] > 0)) // Consulta dentro de la tabla
    {
        if ([tempTBname isEqualToString:tableName]) { // Consultas locales
            
            NSMutableArray *arrayCurrentTableData = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i = 0; i < [arrayField count]; i++) {
        
                [arrayCurrentTableData addObject:[self getTextForFieldInTag:i]];
            }
        
            [self processConsulteInTable:tableName Fields:arrayFields FieldCondition:fieldCond CondOperator:condOperator ConditionValue:value ATBarrayDataField:arrayCurrentTableData ArrayFieldName:arrayFieldNames ArrayFieldCount:(numOfColField * [arrayFieldNames count]) NumRows:numOfColField ThenPlaceItinView:view WithFrame:frame Animation:animate Option_SetArrayDataFieldEqualToArrayResult:NO];
        }
        else if (![tempTBname isEqualToString:tableName])
        {
            [self createAlertWithTitle:@"Information" Message:@"Consultation must be local. For general inquiries should be performed from outside the table." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }

    }
    else if ([ModeGraphORConsol isEqualToString:consoleTableMode])
    {
        if ([tempTBname isEqualToString:tableName]) { // Consultas locales
        
            [self processConsulteInTable:tableName Fields:arrayFields FieldCondition:fieldCond CondOperator:condOperator ConditionValue:value ATBarrayDataField:arrayDataField ArrayFieldName:arrayFieldNames ArrayFieldCount:(numOfColField * [arrayFieldNames count]) NumRows:numOfColField ThenPlaceItinView:view WithFrame:frame Animation:animate Option_SetArrayDataFieldEqualToArrayResult:NO];
        }
        else if (![tempTBname isEqualToString:tableName])
        {
            [self createAlertWithTitle:@"Information" Message:@"Consultation must be local. For general inquiries should be performed from outside the table." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
    }
}

-(void)processConsulteInTable:(NSString *)tableName Fields:(NSMutableArray *)arrayFields FieldCondition:(NSString *)fieldCond CondOperator:(NSString *)condOperator ConditionValue:(id)value ATBarrayDataField:(NSMutableArray *)ArrayDataField ArrayFieldName:(NSMutableArray *)arrayFieldName ArrayFieldCount:(NSInteger)arrayFieldCount /*(NSMutableArray *)arrayField*/ NumRows:(NSInteger )numRows ThenPlaceItinView:(UIView *)inView WithFrame:(CGRect)rect  Animation:(BOOL)animate Option_SetArrayDataFieldEqualToArrayResult:(BOOL)setArrayDataEqualToQueryResult
{
    
    NSLog(@"RR _ %@ _ %@",condOperator,[value class]);
    
    NSMutableArray * arrayResult = [[NSMutableArray alloc] initWithCapacity:0];
    BOOL breakAll = NO;
    
    NSMutableArray *arrayIdxFields = [[NSMutableArray alloc] initWithCapacity:0]; // Contiene el indice de los campos donde se buscaran los datos. (columna 0 idx0...
    NSString *reasonMessageError;  // Muestra la razon del error
    
    BOOL ffound = NO;
    BOOL breakit = NO;
    NSString *aggregatedFuntionField = @"";// Guarda el nombre del campo a la que se le asigna la funcion de agregado. max(%@), min(%@), ...
    BOOL valueEqualToZero = YES;
    BOOL valueExist = NO;

    for (int a = 0; a < [arrayFields count]; a++) {  // Busca los campos establecidos en el query en el array de campos. Si el campo establecido no existe en la tabla se finalizara el proceso.
        
        for (int i = 0; i < [arrayFieldName count]; i++) {
            
            if ([[arrayFields objectAtIndex:a] isEqualToString:[arrayFieldName objectAtIndex:i]]) {  // Confirmando los campos introducidos
                    
                ffound = YES;
                [arrayIdxFields addObject:[NSString stringWithFormat:@"%i",(int)i]];
            }
            else if ([arrayFields count] == 1 && ([[arrayFields objectAtIndex:0] isEqualToString:@"*"] || [[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:@"count(*)"] || [[[arrayFields objectAtIndex:0] lowercaseString]isEqualToString:[NSString stringWithFormat:@"max(%@)",[[arrayFieldName objectAtIndex:i] lowercaseString]]] || [[[arrayFields objectAtIndex:0] lowercaseString]isEqualToString:[NSString stringWithFormat:@"min(%@)",[[arrayFieldName objectAtIndex:i] lowercaseString]]] || [[[arrayFields objectAtIndex:0] lowercaseString]isEqualToString:[NSString stringWithFormat:@"sum(%@)",[[arrayFieldName objectAtIndex:i] lowercaseString]]] || [[[arrayFields objectAtIndex:0] lowercaseString]isEqualToString:[NSString stringWithFormat:@"avg(%@)",[[arrayFieldName objectAtIndex:i] lowercaseString]]]))  // Controlando los campos y las funciones de agregado
            {
                if ([[arrayFields objectAtIndex:0] isEqualToString:@"*"]) {
                    
                    for (int i = 0; i < [arrayFieldName count]; i++) { // Indicando que buscara en todos los campos
                        [arrayIdxFields addObject:[NSString stringWithFormat:@"%i",(int)i]];
                }}
                else if ([[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:@"count(*)"]) // Devolvera la cantidad de campos
                {
                    [arrayIdxFields addObject:[NSString stringWithFormat:@"count(*)"]];
                }
                else if ([[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:[NSString stringWithFormat:@"max(%@)",[[arrayFieldName objectAtIndex:i] lowercaseString]]]) // Devolvera el campo mas grande de la tabla.
                {
                    [arrayIdxFields addObject:[NSString stringWithFormat:@"%i",(int)i]]; // Indice del campo en el array de campos
                    [arrayIdxFields addObject:[NSString stringWithFormat:@"max()"]]; // Identificador
                    aggregatedFuntionField = [arrayFieldName objectAtIndex:i]; // Posee el nombre del campo en funcion
                }
                else if ([[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:[NSString stringWithFormat:@"min(%@)",[[arrayFieldName objectAtIndex:i] lowercaseString]]]) // Devolvera el campo mas grande de la tabla.
                {
                    [arrayIdxFields addObject:[NSString stringWithFormat:@"%i",(int)i]]; // Indice del campo en el array de campos
                    [arrayIdxFields addObject:[NSString stringWithFormat:@"min()"]]; // Identificador
                    aggregatedFuntionField = [arrayFieldName objectAtIndex:i]; // Posee el nombre del campo en funcion
                }
                else if ([[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:[NSString stringWithFormat:@"sum(%@)",[[arrayFieldName objectAtIndex:i] lowercaseString]]]) // Devolvera el campo mas grande de la tabla.
                {
                    [arrayIdxFields addObject:[NSString stringWithFormat:@"%i",(int)i]]; // Indice del campo en el array de campos
                    [arrayIdxFields addObject:[NSString stringWithFormat:@"sum()"]]; // Identificador
                    aggregatedFuntionField = [arrayFieldName objectAtIndex:i]; // Posee el nombre del campo en funcion
                }
                else if ([[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:[NSString stringWithFormat:@"avg(%@)",[[arrayFieldName objectAtIndex:i] lowercaseString]]]) // Devolvera el campo mas grande de la tabla.
                {
                    [arrayIdxFields addObject:[NSString stringWithFormat:@"%i",(int)i]]; // Indice del campo en el array de campos
                    [arrayIdxFields addObject:[NSString stringWithFormat:@"avg()"]]; // Identificador
                    aggregatedFuntionField = [arrayFieldName objectAtIndex:i]; // Posee el nombre del campo en funcion
                }
                
                    ffound = YES;
                    breakit = YES;
                    break;
            }
            
        }
        if (ffound == NO) {  // Si no encuentra ningun campo indicado, finaliza la tarea
            
            reasonMessageError = [NSString stringWithFormat:@"\"%@\" can not be processed.",[arrayFields objectAtIndex:a]];
            breakAll = YES;
            break;
        }
        else if (breakit == YES) {
            break;
        }
    }
    
    if (breakAll == NO && [fieldCond length] > 0) {
        
        breakAll = YES;
        BOOL existFieldCond = NO;
        for (int i = 0; i < [arrayFieldName count]; i++) {  // Comfirma que existe el campo condicional en el array de campos
        
            if ([fieldCond isEqualToString:[arrayFieldName objectAtIndex:i]]) {
                existFieldCond = YES;
                breakAll = NO;
                break;
            }
    }
    if (existFieldCond == NO) { reasonMessageError = [NSString stringWithFormat:@"The conditional field \"%@\" does not match any field in the table.",fieldCond]; }
    }
    
    if (breakAll == NO) {

        [self convertInCoordinatesFromTag:(arrayFieldCount -1) numRows:numRows];  // Obtiene la cantidad de campos (nombre de campos) y filas que tiene hay en la tabla. coorYcol contiene la cantidad de campos en la tabla, coorXRows contiene la cantidad de filas en la tabla
        
        // Verifica el tamaño del objeto valor; que posee el valor condicional de la consulta
        if ([value class] == NSClassFromString(@"__NSArrayM")) { if([value count] == 0) { valueEqualToZero = YES; } else { valueEqualToZero = NO; }}
        else if ([value class] == NSClassFromString(@"__NSCFString")) { if([value length] == 0) { valueEqualToZero = YES; } else { valueEqualToZero = NO; }}
        
        // SELECT * or exc ,(aggregate funtions)  FROM TABLA
        if ([arrayFields count] != 0 && [tableName length] != 0 && [fieldCond length] == 0 && [condOperator length] == 0 && valueEqualToZero == YES) // value == 0)
        {
        
            if ([arrayFields count] == 1 && ([[arrayFields objectAtIndex:0] isEqualToString:@"*"] || [[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:@"count(*)"] || [[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:[NSString stringWithFormat:@"max(%@)",[aggregatedFuntionField lowercaseString]]] || [[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:[NSString stringWithFormat:@"min(%@)",[aggregatedFuntionField lowercaseString]]] || [[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:[NSString stringWithFormat:@"sum(%@)",[aggregatedFuntionField lowercaseString]]] || [[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:[NSString stringWithFormat:@"avg(%@)",[aggregatedFuntionField lowercaseString]]])) { //  Hay un solo campo en el array y es una funcion de agregado
                
                if ([[arrayFields objectAtIndex:0] isEqualToString:@"*"]) {  // * Obtiene todos los datos de cada campo
                    
                    for (int a = 0; a < coorXrow; a++) {  // Lineas de la tabla.
                
                        for (int b = 0; b < coorYcol; b++) {  // Campos de la tabla.
                
                            [arrayResult addObject:[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]]];
                        }
                }}
                else if ([[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:@"count(*)"]) // Devuelve la cantidad de filas en la tabla
                {
                    [arrayResult addObject:[NSString stringWithFormat:@"%i",(int)numRows]];  // Numero de filas en la tabla
                }
                else if ([[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:[NSString stringWithFormat:@"max(%@)",[aggregatedFuntionField lowercaseString]]] || [[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:[NSString stringWithFormat:@"min(%@)",[aggregatedFuntionField lowercaseString]]] || [[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:[NSString stringWithFormat:@"sum(%@)",[aggregatedFuntionField lowercaseString]]] || [[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:[NSString stringWithFormat:@"avg(%@)",[aggregatedFuntionField lowercaseString]]])  // procesando funciones de agregado
                {
                    double dataValues = 0;
                    NSString * dataResult = @"";
                    NSInteger countAvg = 0;
                    NSNumberFormatter *number = [[NSNumberFormatter alloc] init];
                    BOOL getMinValue = YES;
                    BOOL isNumeric = NO;
                    BOOL allDataIsNumeric = YES;
                    
                    for (int a = 0; a < coorXrow; a++) { // Recorriendo cada campo para comparar su valor
                        
                        for (int b = 0; b < coorYcol; b++) {  // Campos de la tabla
                            
                            if ([[NSString stringWithFormat:@"%i",b] isEqualToString:[arrayIdxFields objectAtIndex:0]]) { // La posicion 0 posee el indice del campo en el que trabajara
                                
                             isNumeric = [number numberFromString:[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]]] !=nil;
                                
                                if (isNumeric == NO && allDataIsNumeric == YES && ![[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] isEqualToString:@""] && ![[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] isEqualToString:@" "]) {
                                    
                                    allDataIsNumeric = NO;
                                }
                                
                                if (isNumeric == YES) {
                            
                                if ([[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:[NSString stringWithFormat:@"max(%@)",[aggregatedFuntionField lowercaseString]]]) {  // Devuelve el valor mas grande del campo
                  
                                    if ([[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] doubleValue] >= dataValues) {
                                
                                        dataValues = [[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] doubleValue];
                                        
                                        dataResult = [ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]];
                                }}
                                
                                else if ([[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:[NSString stringWithFormat:@"min(%@)",[aggregatedFuntionField lowercaseString]]]) {
                                    
                                    if (getMinValue == YES) { dataValues = [[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] doubleValue]; getMinValue = NO; }
                                    
                                    if ([[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] doubleValue] <= dataValues) {
                                        
                                        dataValues = [[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] doubleValue];
                                        
                                        dataResult = [ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]];
                                }}
                                
                                else if ([[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:[NSString stringWithFormat:@"sum(%@)",[aggregatedFuntionField lowercaseString]]]) {
                                    
                                    dataValues = dataValues + [[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] doubleValue];
                                    
                                    dataResult = [NSString stringWithFormat:@"%f",dataValues];
                                }
                                    
                                else if ([[[arrayFields objectAtIndex:0] lowercaseString] isEqualToString:[NSString stringWithFormat:@"avg(%@)",[aggregatedFuntionField lowercaseString]]]) {
                                    
                                    countAvg ++;
                                    dataValues = dataValues + [[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] doubleValue];
                                    
                                    dataResult = [NSString stringWithFormat:@"%f",(dataValues / countAvg)];
                                }
                            
                            }}
                            else if (![[NSString stringWithFormat:@"%i",b] isEqualToString:[arrayIdxFields objectAtIndex:0]])
                            {
                                continue;
                            }
                    }}
                    
                    if (allDataIsNumeric == NO) // El dato del campo numerico es alfabetico (no deberia ocurrir por restrincion del metodo de analisis de datos)
                    {
                        [self createAlertWithTitle:@"Information" Message:@"One or few fields were not processed, It are not numeric fields." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
                    }
                    
                    [arrayResult addObject:dataResult];
                }
            }
            else{  // Buscando campos especificos. Puede ser uno o varios a la vez. En este caso si solo hay un campo especificado, no es una funcion de agregado
                
                for (int a = 0; a < coorXrow; a++) {  // Lineas de la tabla
            
                for (int b = 0; b < coorYcol; b++) {  // Campos de la tabla
                
                    for (int i = 0; i < [arrayIdxFields count]; i++) {
                            
                        if ([[NSString stringWithFormat:@"%i",b] isEqualToString:[arrayIdxFields objectAtIndex:i]]) {
                        
                            [arrayResult addObject:[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]]];
            }}}}}}
        
        // SELECT * or exc FROM TABLA WHERE FIELD OPERATOR VALUE
        else if ([arrayFields count] != 0 && [tableName length] != 0 && [fieldCond length] != 0 && [condOperator length] != 0 &&  valueEqualToZero == NO) //[value length] != 0)
        {
            
            if ([arrayFields count] == 1 && [[arrayFields objectAtIndex:0] isEqualToString:@"*"]) {  // * Obtiene todos los datos de cada campo
                
                for (int a = 0; a < coorXrow; a++) {  // Lineas de la tabla
                    
                for (int b = 0; b < coorYcol; b++) {  // Campos de la tabla
            
                if ([condOperator isEqualToString:@"="]) { // El valor puede ser numerico o string
                        
                    if ([[arrayFieldName objectAtIndex:b] isEqualToString:fieldCond] && [[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] isEqualToString:value])  { // Esta en el campo cond y existe el valor condicional.
                            
                        for (int i = 0; i < coorYcol; i++) {  // Obtiene todos los valores
                                
                            [arrayResult addObject:[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(i + 1) NumRows:numRows]]];
                        }
                    }}
                else if ([condOperator isEqualToString:@">"] || [condOperator isEqualToString:@"<"]) // Valor debe ser numerico para obt result.
                {
                    
                    if (([condOperator isEqualToString:@">"] && [[arrayFieldName objectAtIndex:b] isEqualToString:fieldCond] && [[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] floatValue] > [value floatValue]) || ([condOperator isEqualToString:@"<"] && [[arrayFieldName objectAtIndex:b] isEqualToString:fieldCond] && [[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] floatValue] < [value floatValue]))  { // Esta en el campo cond y existe el valor condicional cumple la condicion.
                            
                        for (int i = 0; i < coorYcol; i++) {  // Obtiene todos los valores
                                
                            [arrayResult addObject:[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(i + 1) NumRows:numRows]]];
                        }
                    }
                }
                else if ([condOperator.lowercaseString isEqualToString:@"in"])
                {
                    for (int pos = 0; pos < [value count]; pos++) {
                    
                    if ([[arrayFieldName objectAtIndex:b] isEqualToString:fieldCond] && [[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] isEqualToString:[value objectAtIndex:pos]])  { // Esta en el campo cond y existe el valor condicional.
                        
                        for (int c = 0; c < coorYcol; c++) {
                            
                            for (int i = 0; i < [arrayIdxFields count]; i++) {
                                
                                if ([[NSString stringWithFormat:@"%i",c] isEqualToString:[arrayIdxFields objectAtIndex:i]]) {
                                    
                                    [arrayResult addObject:[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(c + 1) NumRows:numRows]]];
                        }}}}
                    }
                }
                else if ([condOperator.lowercaseString isEqualToString:@"!in"])
                {
                    NSLog(@"Not In Array");
                    
                    valueExist = NO;
                    if ([[arrayFieldName objectAtIndex:b] isEqualToString:fieldCond]) {
                        
                        for (int cv = 0; cv < [value count]; cv++) {
                            
                            if (![[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] isEqualToString:[value objectAtIndex:cv]]) {
                                // Esta en el campo cond y no existe el valor condicional.
                                
                                valueExist = NO;
                            }
                            else{valueExist = true; break;}
                        }
                        
                        if (!valueExist) {
                            
                            for (int c = 0; c < coorYcol; c++) {
                                
                                for (int i = 0; i < [arrayIdxFields count]; i++) {
                                    
                                    if ([[NSString stringWithFormat:@"%i",c] isEqualToString:[arrayIdxFields objectAtIndex:i]]) {
                                        
                                        [arrayResult addObject:[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(c + 1) NumRows:numRows]]];
                                    }}}
                        }
                    }
                    
                    }
                }}}
            else if ([arrayFields count] > 0 && ![[arrayFields objectAtIndex:0] isEqualToString:@"*"])  // Buscando campos especificos.
            {
                for (int a = 0; a < coorXrow; a++) {  // Lineas de la tabla
                    
                    for (int b = 0; b < coorYcol; b++) {  // Campos de la tabla
                        
                    if ([condOperator isEqualToString:@"="]) { // El valor puede ser numerico o string
                            
                        if ([[arrayFieldName objectAtIndex:b] isEqualToString:fieldCond] && [[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] isEqualToString:value])  { // Esta en el campo cond y existe el valor condicional.
                            
                            for (int c = 0; c < coorYcol; c++) {
                            
                            for (int i = 0; i < [arrayIdxFields count]; i++) {
                                
                                if ([[NSString stringWithFormat:@"%i",c] isEqualToString:[arrayIdxFields objectAtIndex:i]]) {
                            
                                    [arrayResult addObject:[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(c + 1) NumRows:numRows]]];
                    }}}}}
                    else if ([condOperator isEqualToString:@">"] || [condOperator isEqualToString:@"<"]) // Valor debe ser numerico para obt result.
                    {
                        
                        if (([condOperator isEqualToString:@">"] && [[arrayFieldName objectAtIndex:b] isEqualToString:fieldCond] && [[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] floatValue] > [value floatValue]) || ([condOperator isEqualToString:@"<"] && [[arrayFieldName objectAtIndex:b] isEqualToString:fieldCond] && [[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] floatValue] < [value floatValue]))  { // Esta en el campo cond y existe el valor condicional cumple la condicion.
                            
                            for (int c = 0; c < coorYcol; c++) {
                                
                            for (int i = 0; i < [arrayIdxFields count]; i++) {
                                
                                if ([[NSString stringWithFormat:@"%i",c] isEqualToString:[arrayIdxFields objectAtIndex:i]]) {
                                    
                                    [arrayResult addObject:[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(c + 1) NumRows:numRows]]];
                        }}}}
                    }
                    else if ([condOperator.lowercaseString isEqualToString:@"in"])
                    {
                        for (int pos = 0; pos < [value count]; pos++) {
                            
                            if ([[arrayFieldName objectAtIndex:b] isEqualToString:fieldCond] && [[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] isEqualToString:[value objectAtIndex:pos]])  { // Esta en el campo cond y existe el valor condicional.
                                
                                for (int c = 0; c < coorYcol; c++) {
                                    
                                    for (int i = 0; i < [arrayIdxFields count]; i++) {
                                        
                                        if ([[NSString stringWithFormat:@"%i",c] isEqualToString:[arrayIdxFields objectAtIndex:i]]) {
                                            
                                            [arrayResult addObject:[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(c + 1) NumRows:numRows]]];
                        }}}}}
                    }
                    else if ([condOperator.lowercaseString isEqualToString:@"!in"])
                    {
                        NSLog(@"Not In Array. -select fields");
                        valueExist = NO;
                        if ([[arrayFieldName objectAtIndex:b] isEqualToString:fieldCond]) {
                            
                            for (int cv = 0; cv < [value count]; cv++) {
                                
                                if (![[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] isEqualToString:[value objectAtIndex:cv]]) {
                                    // Esta en el campo cond y no existe el valor condicional.
                                    
                                    valueExist = NO;
                                }
                                else{valueExist = true; break;}
                            }
                            
                            if (!valueExist) {
                                
                                for (int c = 0; c < coorYcol; c++) {
                                    
                                    for (int i = 0; i < [arrayIdxFields count]; i++) {
                                        
                                        if ([[NSString stringWithFormat:@"%i",c] isEqualToString:[arrayIdxFields objectAtIndex:i]]) {
                                            
                                            [arrayResult addObject:[ArrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(c + 1) NumRows:numRows]]];
                                        }}}
                            }
                        }
                    }}}}
        }
        
        BOOL aggregateFuntion = NO;
        NSMutableArray *field = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i = 0; i < [arrayFieldName count]; i++) {  // Ordenando los datos
            
            for (int a = 0; a < [arrayIdxFields count]; a++) {
                
                // Controlando las funciones de agregado
                if (![[arrayIdxFields objectAtIndex:a] isEqualToString:@"count(*)"] && ![[arrayIdxFields objectAtIndex:a] isEqualToString:@"max()"] && ![[arrayIdxFields objectAtIndex:a] isEqualToString:@"min()"] && ![[arrayIdxFields objectAtIndex:a] isEqualToString:@"sum()"] && ![[arrayIdxFields objectAtIndex:a] isEqualToString:@"avg()"]) { // Si el campo en proceso no es una funcion de agregado...
                
                    if (i == [[arrayIdxFields objectAtIndex:a]  intValue]) { // Asigna el nombre del campo (arrayIdxFields posee en indice de los campos ordenados)
                        [field addObject:[arrayFieldName objectAtIndex:i]];
                    }
                }
                // Funcion de agregado
                else
                {
                    [field removeAllObjects];
                    if ([[arrayIdxFields objectAtIndex:a] isEqualToString:@"count(*)"]) {
                        
                        [field addObject:@"TOTAL AMOUNT"];
                        aggregateFuntion = YES;
                    }
                    else if([[arrayIdxFields objectAtIndex:1] isEqualToString:@"max()"]) // 1: Indice del identificador
                    {
                        [field addObject:@"MAXIMUN VALUE"];
                        aggregateFuntion = YES;
                    }
                    else if([[arrayIdxFields objectAtIndex:1] isEqualToString:@"min()"]) // 1: Indice del identificador
                    {
                        [field addObject:@"MINIMUN VALUE"];
                        aggregateFuntion = YES;
                    }
                    else if([[arrayIdxFields objectAtIndex:1] isEqualToString:@"sum()"]) // 1: Indice del identificador
                    {
                        [field addObject:@"TOTAL"];
                        aggregateFuntion = YES;
                    }
                    else if([[arrayIdxFields objectAtIndex:1] isEqualToString:@"avg()"]) // 1: Indice del identificador
                    {
                        [field addObject:@"AVERAGE"];
                        aggregateFuntion = YES;
                    }
                    break;
                }
            }
            
            if (aggregateFuntion == YES) {
                break;
            }
        }
        
        [self createNewHistoryConsultWithQuery:quertyTextField.text CreateHistoricQueryButtons:YES WithFrame:CGRectMake(40, 0, recentQueryScroll.frame.size.width - 80, 40) InView:recentQueryScroll UseArrayQuery:recentQuerys];
        
        if (setArrayDataEqualToQueryResult == YES) // Copia los datos del resultados en arrayDataField
        {
            [arrayDataField removeAllObjects];
            [arrayFieldNames removeAllObjects];
            numOfColField = 0;
            
            for (int i = 0; i < [field count]; i++) {  // Nombre de los campos
        
                for (int a = 0; a < [arrayResult count]; a++) { // Datos
                    
                    if (((a * [field count]) + i) < [arrayResult count]) {
                        
                        [arrayDataField addObject:[arrayResult objectAtIndex:((a * [field count]) + i)]];
                        
                    }
                    else {break;}
                }
           }
            
            arrayFieldNames = [field mutableCopy];
            numOfColField = (int)([arrayDataField count] / [field count]);
        }
        
        if (animate == YES) {
            
            [excelTableView setAlpha:0.5];
            [self createConsoleTableViewAtFrame:rect InView:inView ArrayDataField:arrayResult ArrayFieldNames:field txtViewWidth:150 Alpha:0.0 ThenSetInformationIfisNeeded:nil];
            
            [UIView beginAnimations:NULL context:NULL];
            [UIView setAnimationDuration:0.5];
            [tableConsoleView setAlpha:1.0];
            [UIView commitAnimations];
            
        } else if (animate == NO) {
            
         [self createConsoleTableViewAtFrame:rect InView:inView ArrayDataField:arrayResult ArrayFieldNames:field txtViewWidth:150 Alpha:1.0 ThenSetInformationIfisNeeded:nil];
        }
        
    }
    else if (breakAll == YES)
    {
        [self createAlertWithTitle:@"Not match" Message:[NSString stringWithFormat:@"The query is not written appropiately, or some field are not in the table or are wrote incorrectly, please read and follow the instruction that show how to write it. \n\n Reason: %@",reasonMessageError] CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        
        errorAssistantConsult = YES; // permite notificar el error. Indica en cual consulta estubo el error (Consulta avanzada)
    }
}

# pragma SENTENCIA INSERT
-(void)insertIntoTable:(NSString *)table InFields:(NSMutableArray *)fields Values:(NSMutableArray *)values Database:(NSString *)database
{
    NSLog(@"v: %@",values);
    [self allocTableWithDataBaseName:database AtPath:[NSString stringWithFormat:@"%@/%@/%@",oneDataDirPath,database,table] FUNTION:@"NONE" MODE:ModeGraphORConsol];  // Cargando los datos de la tabla.
    
    BOOL fieldFound = NO;
    BOOL numeric = NO;
    BOOL process = NO;
    BOOL rowEmpty = NO;
    BOOL dataExist = NO;
    NSInteger RowEmpty = 0;
    NSNumberFormatter * number = [[NSNumberFormatter alloc] init];
    NSMutableArray *arrayIndexField = [[NSMutableArray alloc] init];
    NSString *errorMessage = @"";
    
    if ([fields count] > 0) { // Campos establecidos. Identifica los campos no encontrados y ordena los campos establecidos con el orden de los campos definidos.
        
        if ([fields count] == [values count]) {
        
            for (int i = 0; i < [fields count]; i++) {
        
            for (int fx = 0; fx < [arrayFieldNames count]; fx++) {
                
                if ([[arrayFieldNames objectAtIndex:fx] isEqualToString:[fields objectAtIndex:i]]) { [arrayIndexField addObject:[NSString stringWithFormat:@"%i",fx]]; fieldFound = YES; break;}
            }
                if (fieldFound == NO) { errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@"The field \"%@\" does not exist.",[fields objectAtIndex:i]]]; break;}
            }
        }else { errorMessage = @"There is not the same number of values as specified fields. Must have as many values as fields"; }
    }
    else if ([fields count] == 0) { // Campos no establecidos. Inserccion en general.
        
        if ([values count] == [arrayFieldNames count]) {
            
            for (int i = 0; i < [arrayFieldNames count]; i++) {
                
                [arrayIndexField addObject:[NSString stringWithFormat:@"%i",i]]; // Guardara en todos los campos.
            }
        }
        else if ([values count] != [arrayFieldNames count])
        {
            NSString * infoNumFields = @"";
            NSString * infoNumValues = @"";
            
            if ([arrayFieldNames count] > 1) { infoNumFields = [NSString stringWithFormat:@"There are %i fields in the table",(int)[arrayFieldNames count]];
            } else {infoNumFields = [NSString stringWithFormat:@"There is %i field in the table.",(int)[arrayFieldNames count]]; }
            
            if ([values count] > 1) { infoNumValues = [NSString stringWithFormat:@"%i values specified.",(int)[values count]];
            } else {infoNumValues = [NSString stringWithFormat:@"%i value specified.",(int)[values count]]; }
            
            errorMessage = [NSString stringWithFormat:@"You must specify the same number of values as fields in the table. %@ and %@",infoNumFields,infoNumValues];
        }
        
    }
    
    NSLog(@"{%@} {%@}",arrayIndexField,values);
    
    if (fieldFound == YES || [fields count] == 0) { // Proceso en los campos indicados o en general.
        
        [self convertInCoordinatesFromTag:((numOfColField * [arrayFieldNames count]) -1) numRows:numOfColField];  // Obtiene la cantidad de campos (nombre de campos) y filas que tiene hay en la tabla. coorYcol contiene la cantidad de campos en la tabla, coorXRows contiene la cantidad de filas en la tabla
        
        
        //  INSERT INTO TABLE VALUES. Guardara los datos si no existe algun dato en la fila
        
            for (int a = 0; a < coorXrow; a++) {  // Lineas de la tabla
                
                for (int b = 0;  b < coorYcol; b++) { // Campos de la tabla. verifica las filas de la tabla, si cada campo en la fila posee un valor nulo o vacio, se tomara como linea utilizable. linea utilizable: fila de la tabla disponible para la inserccion de datos.
                    
                    if (([[arrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numOfColField]] isEqualToString:@""] || [[arrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numOfColField]] isEqualToString:@" "]) && [[arrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numOfColField]] length] < 2) { rowEmpty = YES; }
                    else{ rowEmpty = NO; NSLog(@"%@",[arrayDataField objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numOfColField]]); break; }
                }
                if (rowEmpty == YES) {  RowEmpty = a; break; }
            }
            
            if (rowEmpty == YES) {
                
                int column = 0; // Indica la columna del campo a insertar el valor.
                
                for (int i = 0; i < [arrayIndexField count]; i++) {
                
                    if ([arrayIndexField count] > 0) {
                        
                        for (int b = 0; b < coorYcol; b++) {
                        
                            if ([[NSString stringWithFormat:@"%@",[arrayIndexField objectAtIndex:i]] isEqualToString:[NSString stringWithFormat:@"%i",b]]) {
                                process = YES; column = b; break;
                            }
                        }
                    }else{ process = YES; }
                    
                if (process == YES) {
                    
                    numeric = [number numberFromString:[values objectAtIndex:i]] != nil;
                
                    if (([[arrayKeyBoardFieldType objectAtIndex:column] isEqualToString:@"Alphabetic"] && numeric == NO) || ([[arrayKeyBoardFieldType objectAtIndex:column] isEqualToString:@"Numeric"] && numeric == YES)) { [arrayDataField replaceObjectAtIndex:[self convertToTagFromCoordinateXrow:RowEmpty Ycol:(column + 1) NumRows:numOfColField] withObject:[values objectAtIndex:i]]; }
                    
                    else if (([[arrayKeyBoardFieldType objectAtIndex:column] isEqualToString:@"PrimaryKey"]) || ([[arrayKeyBoardFieldType objectAtIndex:column] isEqualToString:@"PrimaryKeyN"] && numeric == YES) || ([[arrayKeyBoardFieldType objectAtIndex:column] isEqualToString:@"PrimaryKeyA"] && numeric == NO))
                    {
                        for (int p = 0; p < [arrayDataField count]; p++) {
                        
                            if ([[arrayDataField objectAtIndex:p] isEqualToString:[values objectAtIndex:i]]) { dataExist = YES; break; }
                        }
                    
                        if (dataExist == NO) { [arrayDataField replaceObjectAtIndex:[self convertToTagFromCoordinateXrow:RowEmpty Ycol:(column + 1) NumRows:numOfColField] withObject:[values objectAtIndex:i]]; }
                        else
                        {
                            errorMessage = [NSString stringWithFormat:@"The field %@ has primary key. Its value: %@ already exist.",[arrayFieldNames objectAtIndex:column], [values objectAtIndex:i]];
                            break;
                        }
                    }
                    else
                    {
                        errorMessage = [NSString stringWithFormat:@"The field %@ does not support the content entered.",[arrayFieldNames objectAtIndex:column]];
                        break;
                    }
                }
            }
                
            }
            else if (rowEmpty == NO){ errorMessage = @"the current sheet is complete, please create another sheet. the sheets: dividen the table into sections to allow access to data more smoothly, grouped according to the amount of rows specified of the table."; }
            
    }
    
        if (rowEmpty == YES && [errorMessage length] == 0) {
            
            [self SaveDataBaseWithName:DBName TableName:DBTableName TableContents:[self setTableDatas_TableName:DBTableName ArrayFieldNames:arrayFieldNames ArrayDataFields:arrayDataField] TableMetadata:[self setTableMetadatas_numcolFields:numOfColField PrimaryKey:arrayKeyBoardFieldType]]; // Guarda la estructura de la tabla y sus datos. Todos los arrays fueron cargados previamente, Desde la construccion de la tabla (si esta en ella) o desde su invocacion apartir del nombre de la base de datos y la tabla
            
            [self createAlertWithTitle:@"Query run successful" Message:[NSString stringWithFormat:@"1 Row affected. Row number: %i",(int)(RowEmpty + 1)] CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
            
            [self createNewHistoryConsultWithQuery:quertyTextField.text CreateHistoricQueryButtons:YES WithFrame:CGRectMake(40, 0, recentQueryScroll.frame.size.width - 80, 40) InView:recentQueryScroll UseArrayQuery:recentQuerys];
        }
        else if ([errorMessage length] > 0)
        {
            [self createAlertWithTitle:@"Not match" Message:errorMessage CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
}

# pragma SENTENCIA DELETE
-(void)deleteFromTable:(NSString *)tableName ConditionalField:(NSString *)conditionalField ConditionalOperator:(NSString *)conditionalOperator ConditionalValue:(NSString *)conditionalValue
{
    if ([ModeGraphORConsol isEqualToString:externConsultTableMode]) {  // Realizando la consulta desde la base de datos externa
        
        [self allocTableWithDataBaseName:tempDBname AtPath:[NSString stringWithFormat:@"%@/%@/%@",oneDataDirPath,tempDBname,tableName] FUNTION:@"NONE" MODE:ModeGraphORConsol];  // Cargando los datos de la tabla.
        
        [self processConsulteDeleteFromTable:tableName CondField:conditionalField CondOperator:conditionalOperator CondValue:conditionalValue ArrayDataField:arrayDataField ArrayFieldName:arrayFieldNames ArrayFieldCount:(numOfColField * [arrayFieldNames count]) NumRpws:numOfColField];
    }
    else if ([ModeGraphORConsol isEqualToString:graphicsTableMode] || [ModeGraphORConsol isEqualToString:consoleTableMode])
    {
        if ([ModeGraphORConsol isEqualToString:graphicsTableMode]) {
            
            [self processConsulteDeleteFromTable:tableName CondField:conditionalField CondOperator:conditionalOperator CondValue:conditionalValue ArrayDataField:arrayDataField ArrayFieldName:arrayFieldNames ArrayFieldCount:(numOfColField * [arrayFieldNames count]) NumRpws:numOfColField];
        
            [self autoSetDataFromArray:arrayDataField InFieldForArrayFields:arrayField]; // Inserta los datos del arrayDataField en cada textField
        
        }
        else if ([ModeGraphORConsol isEqualToString:consoleTableMode])
        {
            [self processConsulteDeleteFromTable:tableName CondField:conditionalField CondOperator:conditionalOperator CondValue:conditionalValue ArrayDataField:arrayDataField ArrayFieldName:arrayFieldNames ArrayFieldCount:(numOfColField * [arrayFieldNames count]) NumRpws:numOfColField];
        }
    }
}
-(void)processConsulteDeleteFromTable:(NSString *)table CondField:(NSString *)condField CondOperator:(NSString *)condOperator CondValue:(NSString *)condValue ArrayDataField:(NSMutableArray *)arrayData ArrayFieldName:(NSMutableArray *)arrayFieldName ArrayFieldCount:(NSInteger )arrayFieldCount NumRpws:(NSInteger )numRows
{
    // DELETE FROM TABLE
    if ([table length] > 0 && [condField length] == 0 && [condOperator length] == 0 && [condValue length] == 0) { // Borra todos los datos de la tabla
        
        for (int i = 0; i < [arrayData  count]; i++) {
            
            [arrayData replaceObjectAtIndex:i withObject:@""];
        }
        [self SaveDataBaseWithName:DBName TableName:DBTableName TableContents:[self setTableDatas_TableName:DBTableName ArrayFieldNames:arrayFieldNames ArrayDataFields:arrayData] TableMetadata:[self setTableMetadatas_numcolFields:numOfColField PrimaryKey:arrayKeyBoardFieldType]]; // Guarda la estructura de la tabla y sus datos. Todos los arrays fueron cargados previamente, Desde la construccion de la tabla (si esta en ella) o desde su invocacion apartir del nombre de la base de datos y la tabla
        [self createAlertWithTitle:@"Query run successful" Message:[NSString stringWithFormat:@"%i Rows affected",(int)numRows] CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
    }
    
    // DELETE FROM TABLE WHERE FIELD operator VALUE
    else if ([table length] > 0 && [condField length] > 0 && [condOperator length] > 0 && [condValue length] > 0)
    {  // Busca y elimina filas apartir de un campos especificos.
        
        [self convertInCoordinatesFromTag:(arrayFieldCount -1) numRows:numRows];  // Obtiene la cantidad de campos (nombre de campos) y filas que tiene hay en la tabla. coorYcol contiene la cantidad de campos en la tabla, coorXRows contiene la cantidad de filas en la tabla
        BOOL changes = NO;
        BOOL existField = NO;
        BOOL rowAffected = NO;
        NSInteger rowsAffected = 0;
        NSInteger indexField = 0; // Indice (del campo a trabajar) en el arrayFieldName
        for (int i = 0; i < [arrayFieldName count]; i++) {  // Tomando el indice del campo condicional (del origen)
            
            if ([[arrayFieldName objectAtIndex:i] isEqualToString:condField]) { indexField = i; existField = YES; break; }
        }
        
        if (existField == YES) {
            
        for (int a = 0; a < coorXrow; a++) {  // Lineas de la tabla
            
            if (rowAffected == YES) { rowsAffected ++; rowAffected = NO; }
           
            for (int b = 0; b < coorYcol; b++) {  // Campos de la tabla
                
                if ([condOperator isEqualToString:@"="]) {
                    
                if ([[NSString stringWithFormat:@"%i",b] isEqualToString:[NSString stringWithFormat:@"%i",(int)indexField]] && [[arrayData objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] isEqualToString:condValue]) {
                    
                    for (int i = 0; i < coorYcol; i++) {  // Campos de la tabla
                        
                        [arrayData replaceObjectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(i + 1) NumRows:numRows] withObject:@""];
                        changes = YES;
                        rowAffected = YES;
                }}}
                else if ([condOperator isEqualToString:@">"] || [condOperator isEqualToString:@"<"])
                {
                    if ([condOperator isEqualToString:@">"]) {
                        
                        if ([[NSString stringWithFormat:@"%i",b] isEqualToString:[NSString stringWithFormat:@"%i",(int)indexField]] && [[arrayData objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] floatValue] > [condValue floatValue] ) {
                            
                            for (int i = 0; i < coorYcol; i++) {  // Campos de la tabla
                                
                                [arrayData replaceObjectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(i + 1) NumRows:numRows] withObject:@""];
                                changes = YES;
                                rowAffected = YES;
                        }}}
                    else if ([condOperator isEqualToString:@"<"]){
                        
                        if ([[NSString stringWithFormat:@"%i",b] isEqualToString:[NSString stringWithFormat:@"%i",(int)indexField]] && [[arrayData objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] floatValue] < [condValue floatValue] ) {
                            
                            for (int i = 0; i < coorYcol; i++) {  // Campos de la tabla
                                
                                [arrayData replaceObjectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(i + 1) NumRows:numRows] withObject:@""];
                                changes = YES;
                                rowAffected = YES;
                            }}}
                }}}
            
            if (changes == YES) {
                
                [self SaveDataBaseWithName:DBName TableName:DBTableName TableContents:[self setTableDatas_TableName:DBTableName ArrayFieldNames:arrayFieldNames ArrayDataFields:arrayData] TableMetadata:[self setTableMetadatas_numcolFields:numOfColField PrimaryKey:arrayKeyBoardFieldType]]; // Guarda la estructura de la tabla y sus datos. Todos los arrays fueron cargados previamente, Desde la construccion de la tabla (si esta en ella) o desde su invocacion apartir del nombre de la base de datos y la tabla
                
                [self createAlertWithTitle:@"Query run successful" Message:[NSString stringWithFormat:@"%i Rows affected",(int)rowsAffected] CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
            }
            [self createNewHistoryConsultWithQuery:quertyTextField.text CreateHistoricQueryButtons:YES WithFrame:CGRectMake(40, 0, recentQueryScroll.frame.size.width - 80, 40) InView:recentQueryScroll UseArrayQuery:recentQuerys];
        }
        else if (existField == NO){ [self createAlertWithTitle:@"Not match" Message:[NSString stringWithFormat:@"The conditional field \"%@\" does not match any field in the table.",condField] CancelBtnTitle:@"Accept" OtherBtnTitle:nil]; }
        }
}

#pragma SENTENCIA DROP
-(BOOL )dropOBJECT:(NSString *)objectName KindOfObject:(NSString *)object UseDataBase:(NSString *)dbName ArrayDataBase:(NSArray *)arraydb Arraytables:(NSArray *)arraytb RootPath:(NSString *)rootPath
{
    NSString *objectPath;
    BOOL removed = NO;
    
    if ([object isEqualToString:@"database"]) {
        
        objectPath = [NSString stringWithFormat:@"%@/%@",rootPath,objectName];
    }
    else if ([object isEqualToString:@"table"])
    {
        objectPath = [NSString stringWithFormat:@"%@/%@/%@",rootPath,dbName,objectName];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:objectPath] == YES) {
        
       removed = [[NSFileManager defaultManager] removeItemAtPath:objectPath error:nil];
        
        if (removed == YES) {
            
            [self createAlertWithTitle:@"Query run successfully" Message:[NSString stringWithFormat:@"The %@ \'%@\' was remove successfully.",object,objectName] CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
            
            if ([object isEqualToString:@"database"]) {
            
                [self removeScrollDataBase];
                arraydb = [self getDataBaseNamesFromRootpath:rootPath];  // Cargando el array con el nombre de las base de datos en el dispositivo
            }
            else if ([object isEqualToString:@"table"])
            {
                [self removeScrollTables];
                arraytb = [self getTableNamesFromDataBaseName:dbName RootPath:rootPath];

            }
            [self createNewHistoryConsultWithQuery:quertyTextField.text CreateHistoricQueryButtons:YES WithFrame:CGRectMake(40, 0, recentQueryScroll.frame.size.width - 80, 40) InView:recentQueryScroll UseArrayQuery:recentQuerys];
        }
        else if (removed == NO)
        {
            [self createAlertWithTitle:@"Not match" Message:[NSString stringWithFormat:@"The %@ could not be removed.",object] CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
    }
    return removed;
}

#pragma SENTENCIA UPDATE
-(void)updateTable:(NSString *)tableName SETSingleField:(NSString *)singleField SingleOperator:(NSString *)singleOperator SingleValue:(NSString *)singleValue WHEREConditionalField:(NSString *)condField ConditionalOperator:(NSString *)condOperator ConditionalValue:(NSString *)condValue
{
    if ([ModeGraphORConsol isEqualToString:graphicsTableMode] || [ModeGraphORConsol isEqualToString:consoleTableMode]) {
        
        // arrayData, arrayFieldName: actual
        
        [self proccessConsulteUpdateTable:tableName SETSingleField:singleField SingleOperator:singleOperator SingleValue:singleValue WHEREConditionalField:condField ConditionalOperator:condOperator ConditionalValue:condValue arrayData:arrayDataField ArrayFieldName:arrayFieldNames ArrayFieldCount:(numOfColField * [arrayFieldNames count]) NumRows:numOfColField ArrayPrimaryKey:arrayKeyBoardFieldType];
        
        if ([ModeGraphORConsol isEqualToString:graphicsTableMode]){
    
            [self autoSetDataFromArray:arrayDataField InFieldForArrayFields:arrayField]; // Inserta los datos del arrayDataField en cada textField
        }
    }
    else if ([ModeGraphORConsol isEqualToString:externConsultTableMode])
    {
        // arrayData, arrayFieldName: null
        
         [self allocTableWithDataBaseName:tempDBname AtPath:[NSString stringWithFormat:@"%@/%@/%@",oneDataDirPath,tempDBname,tableName] FUNTION:@"NONE" MODE:ModeGraphORConsol];  // Cargando los datos de la tabla.
        
        [self proccessConsulteUpdateTable:tableName SETSingleField:singleField SingleOperator:singleOperator SingleValue:singleValue WHEREConditionalField:condField ConditionalOperator:condOperator ConditionalValue:condValue arrayData:arrayDataField ArrayFieldName:arrayFieldNames ArrayFieldCount:(numOfColField * [arrayFieldNames count]) NumRows:numOfColField ArrayPrimaryKey:arrayKeyBoardFieldType];
    }
}
-(void)proccessConsulteUpdateTable:(NSString *)table SETSingleField:(NSString *)singleField SingleOperator:(NSString *)singleOperator SingleValue:(NSString *)singleValue WHEREConditionalField:(NSString *)condField ConditionalOperator:(NSString *)condOperator ConditionalValue:(NSString *)condValue arrayData:(NSMutableArray *)arrayData ArrayFieldName:(NSMutableArray *)arrayFieldName ArrayFieldCount:(NSInteger)arrayFieldCount NumRows:(NSInteger )numRows ArrayPrimaryKey:(NSMutableArray *)arrayPrimaryKey
{
    BOOL exist;
    BOOL pkFieldFound = NO;
    BOOL breakit = NO;
    BOOL isDataNumeric = NO;
    BOOL rowAffected = NO;
    NSInteger rowsAffected = 0;
    NSString *message = @"";
    
    // verifica que existen los campos establecidos en la tabla.
    for (int i = 0; i < [arrayFieldName count]; i++) {
        
        if ([singleField isEqualToString:[arrayFieldName objectAtIndex:i]]) { exist = YES; break; }
        else {message = singleField;}
    }
    
    if (exist == YES) { // Existe el primer campo (singleField)
        exist = NO;
        for (int i = 0; i < [arrayFieldName count]; i++) {
            
            if (([condField length] > 0 && [condField isEqualToString:[arrayFieldName objectAtIndex:i]]) || [condField length] == 0){ exist = YES; break; } // CondField length = 0, realiza consulta basica: "update table set field operator value"
            else {message = condField;}
        }
    }
    
    if (exist == YES) { // Los campos existen en la tabla
        
        NSNumberFormatter * Number = [[NSNumberFormatter alloc] init];
        isDataNumeric = [Number numberFromString:singleValue] != nil;  // Identifica el tipo de datos a introducir en la tabla para comparalo con el tipo de dato que admite el campo
        
        [self convertInCoordinatesFromTag:(arrayFieldCount -1) numRows:numRows];  // Obtiene la cantidad de campos (nombre de campos) y filas que tiene hay en la tabla. coorYcol contiene la cantidad de campos en la tabla, coorXRows contiene la cantidad de filas en la tabla
        
        if ([table length] > 0 && [singleField length] > 0 && [condField length] == 0) { // Si el campo condicional esta vacio, realizara la consulta: "update table set field operator value".
            
            for (int a = 0; a < coorXrow; a++) {  // Lineas de la tabla
                
                for (int b = 0; b < coorYcol; b++) {  // Campos de la tabla
                    
                    if (coorXrow > 1 && [singleField isEqualToString:[arrayFieldName objectAtIndex:b]] && ([[arrayPrimaryKey objectAtIndex:b] isEqualToString:@"PrimaryKeyN"] || [[arrayPrimaryKey objectAtIndex:b] isEqualToString:@"PrimaryKeyA"] || [[arrayPrimaryKey objectAtIndex:b] isEqualToString:@"PrimaryKey"])) { pkFieldFound = YES; } // Identifica si el campo posee primarykey. Si en la tabla solo hay un registro, podra realizar la tarea ya que no se repetira el mismo dato en la tabla (numrows = 1 :: coorXrow = 1).
                    
                    if ([singleField isEqualToString:[arrayFieldName objectAtIndex:b]] && pkFieldFound == NO) {
                        
                        if (([[arrayPrimaryKey objectAtIndex:b] isEqualToString:@"Alphabetic"] && isDataNumeric == NO) || ([[arrayPrimaryKey objectAtIndex:b] isEqualToString:@"Numeric"] && isDataNumeric == YES)) {
                        
                            [arrayData replaceObjectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows] withObject:singleValue];
                            rowAffected = YES;
                        }
                        else {[self createAlertWithTitle:@"Not match" Message:[NSString stringWithFormat:@"The field \"%@\" does not support the data type specified.",singleField] CancelBtnTitle:@"Accept" OtherBtnTitle:nil]; breakit = YES; break;}
                       
                    }else if (pkFieldFound == YES){ [self createAlertWithTitle:@"Not match" Message:[NSString stringWithFormat:@"The field \"%@\" has primary key.",singleField] CancelBtnTitle:@"Accept" OtherBtnTitle:nil]; breakit = YES; break;}
                }
                if (breakit == YES) { break; }
                if (rowAffected == YES) { rowsAffected ++; rowAffected = NO; }
            }
        }
        else if ([table length] > 0 && [singleField length] > 0 && [condField length] > 0) // Si el campo condicional no esta vacio; deberia existir un operador y un valor condicional. Realizara la consulta: "update table set field operator value where field operator value"
        {
            BOOL found = NO;
            BOOL countData = YES;
            BOOL PrimaryKey = NO;
            NSInteger pkCounter = 0;
            
            for (int a = 0; a < coorXrow; a++) {  // Lineas de la tabla
                
                for (int b = 0; b < coorYcol; b++) {  // Campo (condField)
                    
                if ([condField isEqualToString:[arrayFieldName objectAtIndex:b]]) { // condField --> datos
                    
                    if ([condOperator isEqualToString:@"="]) {
                        
                        if ([condValue isEqualToString:[arrayData objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]]]) { found = YES; }
                        
                        if (found == YES && countData == YES) {  // Cuenta la cantidad de datos en la tabla que cumplen la condicion, Si hay mas de uno y el campo es pk, no realizara la tarea
                            
                            for (int i = 0; i < coorXrow; i++) {
                                
                                if ([condValue isEqualToString:[arrayData objectAtIndex:[self convertToTagFromCoordinateXrow:i Ycol:(b + 1) NumRows:numRows]]]) { pkCounter ++; countData = NO; }
                        }}
                    }
                    else if ([condOperator isEqualToString:@">"])
                    {
                        if ([[arrayData objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] floatValue] > [condValue floatValue]) { found = YES; }
                        
                        if (found == YES && countData == YES) {  // Cuenta la cantidad de datos en la tabla que cumplen la condicion, Si hay mas de uno y el campo es pk, no realizara la tarea
                            
                            for (int i = 0; i < coorXrow; i++) {
                                
                                if ([[arrayData objectAtIndex:[self convertToTagFromCoordinateXrow:i Ycol:(b + 1) NumRows:numRows]] floatValue] > [condValue floatValue]) { pkCounter ++; countData = NO; }
                            }}
                    }
                    else if ([condOperator isEqualToString:@"<"])
                    {
                        if ([[arrayData objectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(b + 1) NumRows:numRows]] floatValue] < [condValue floatValue]) { found = YES; }
                        
                        if (found == YES && countData == YES) {  // Cuenta la cantidad de datos en la tabla que cumplen la condicion, Si hay mas de uno y el campo es pk, no realizara la tarea
                            
                            for (int i = 0; i < coorXrow; i++) {
                                
                                if ([[arrayData objectAtIndex:[self convertToTagFromCoordinateXrow:i Ycol:(b + 1) NumRows:numRows]] floatValue] < [condValue floatValue]) { pkCounter ++; countData = NO; }
                            }}
                    }
                    
                    if (found == YES) { // Condicion encontrada
                        
                        found = NO;
                        for (int c = 0; c < coorYcol; c++) {  // Campo (singleField)
                            
                            if (coorXrow > 1 && [singleField isEqualToString:[arrayFieldName objectAtIndex:c]] && ([[arrayPrimaryKey objectAtIndex:c] isEqualToString:@"PrimaryKeyN"] || [[arrayPrimaryKey objectAtIndex:c] isEqualToString:@"PrimaryKeyA"] || [[arrayPrimaryKey objectAtIndex:c] isEqualToString:@"PrimaryKey"])) { // Identifica si el campo posee primarykey. Si en la tabla solo hay un registro, podra realizar la tarea ya que no se repetira el mismo dato en la tabla (numrows = 1 :: coorXrow = 1).
                                
                                PrimaryKey = YES;
                                
                                if (pkCounter <= 1) { pkFieldFound = NO; } // 1: El dato se repite maximo una vez. realiza la tarea.
                                else if (pkCounter > 1) { pkFieldFound = YES; } // El dato se repite mas de una vez. no realiza la tarea.
                                
                                if (pkFieldFound == NO) { // 2: revalidacion
                                    
                                    for (int i = 0; i < coorXrow; i++) { // Verificando que el dato que se introducira en el campo (PK) no exista
                                        
                                        if ([[arrayData objectAtIndex:[self convertToTagFromCoordinateXrow:i Ycol:(c + 1) NumRows:numRows]] isEqualToString:singleValue]) { pkFieldFound = YES; break; }
                                }}
                            }
                            
                            if ([singleField isEqualToString:[arrayFieldName objectAtIndex:c]] && pkFieldFound == NO) { // singleField --> datos
                                
                            if (([[arrayPrimaryKey objectAtIndex:c] isEqualToString:@"Alphabetic"] && isDataNumeric == NO) || ([[arrayPrimaryKey objectAtIndex:c] isEqualToString:@"Numeric"] && isDataNumeric == YES) || (PrimaryKey == YES && pkCounter <= 1)) {
                                
                                    [arrayData replaceObjectAtIndex:[self convertToTagFromCoordinateXrow:a Ycol:(c + 1) NumRows:numRows] withObject:singleValue];
                                    rowAffected = YES;
                            }
                            else {[self createAlertWithTitle:@"Not match" Message:[NSString stringWithFormat:@"The field \"%@\" does not support the data type specified.",singleField] CancelBtnTitle:@"Accept" OtherBtnTitle:nil]; breakit = YES; break;}
                            }
                            else if (pkFieldFound == YES){ [self createAlertWithTitle:@"Not match" Message:[NSString stringWithFormat:@"The field \"%@\" has primary key.",singleField] CancelBtnTitle:@"Accept" OtherBtnTitle:nil]; breakit = YES; break;}
                    }}}
                }
                if (breakit == YES) { break; }
                if (rowAffected == YES) { rowsAffected ++; rowAffected = NO; }
            }
        }
        [self SaveDataBaseWithName:DBName TableName:DBTableName TableContents:[self setTableDatas_TableName:DBTableName ArrayFieldNames:arrayFieldNames ArrayDataFields:arrayData] TableMetadata:[self setTableMetadatas_numcolFields:numOfColField PrimaryKey:arrayKeyBoardFieldType]]; // Guarda la estructura de la tabla y sus datos. Todos los arrays fueron cargados previamente, Desde la construccion de la tabla (si esta en ella) o desde su invocacion apartir del nombre de la base de datos y la tabla
        
        [self createAlertWithTitle:@"Query run successful" Message:[NSString stringWithFormat:@"%i Rows affected",(int)rowsAffected] CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        
        [self createNewHistoryConsultWithQuery:quertyTextField.text CreateHistoricQueryButtons:YES WithFrame:CGRectMake(40, 0, recentQueryScroll.frame.size.width - 80, 40) InView:recentQueryScroll UseArrayQuery:recentQuerys];
    }
    else if (exist == NO)
    {
        [self createAlertWithTitle:@"Not match" Message:[NSString stringWithFormat:@"The field \"%@\" does not exist in the table, make sure it is well written.",message] CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
    }
}

# pragma EXTRAE LOS QUERIES Y REALIZA LA CONSULTA
-(void)makeAdvancedConsult_ArrayQuerySelections:(NSMutableArray *)arraySelections // Extrae los queries del array y realiza la consulta. Cada consulta arrojara un resultado, (seran los datos que procesara la siguiente consulta)
{
    for (int i  = 0; i < [arrayClearTextFieldButtons count]; i++) {
        
        [(UIButton *)[arrayClearTextFieldButtons objectAtIndex:i] setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
    }
    
    for (NSInteger i = 0; i < [arraySelections count]; i++) {
        
        if ([[arraySelections objectAtIndex:i] length] > 0) {
            
            [self consultAction:[arraySelections objectAtIndex:i] ConsultType:@"ADVANCED"];
            
            if (errorAssistantConsult == NO) {
        
                [(UIButton *)[arrayClearTextFieldButtons objectAtIndex:i] setTitleColor:AssistantQueryIndicator forState:UIControlStateNormal];
            }
            else
            {
                [(UIButton *)[arrayClearTextFieldButtons objectAtIndex:i] setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                break;
            }
        }
    }
    
    [arrayDataField removeAllObjects];
    [arrayFieldNames removeAllObjects];
    numOfColField = 0;
}

# pragma HISTORIAL DE CONSULTAS (SOLO PARA CONSULTAS EXTERNAS)
-(void)createNewHistoryConsultWithQuery:(NSString *)currentQuery CreateHistoricQueryButtons:(BOOL)createHistoricBtns WithFrame:(CGRect)rect InView:(id)view UseArrayQuery:(NSMutableArray *)recentQuerys
{
    [recentQuerys addObject:currentQuery];
    
    if (createHistoricBtns == YES) {
        
        NSInteger Ypos = (((rect.size.height) ) * ([recentQuerys count] - 1));
    
        UIButton *queryBtn = [[UIButton alloc] initWithFrame:CGRectMake(rect.origin.x, Ypos, 50, rect.size.height)];
        [queryBtn setTitle:currentQuery forState:UIControlStateNormal];
        [queryBtn setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
        [queryBtn.titleLabel setFont:HeitiTC_14];
        [queryBtn sizeToFit];
        [queryBtn setTag:[recentQuerys count]];
        [queryBtn addTarget:self action:@selector(setRecentQueryInConsultTextFieldFromQueryButtonPressedWithTag:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:queryBtn];
            
        [view setContentSize:CGSizeMake(0, Ypos + rect.size.height)];
    }
}
-(void)setRecentQueryInConsultTextFieldFromQueryButtonPressedWithTag:(id)sender
{
    [quertyTextField setText:[recentQuerys objectAtIndex:([sender tag] - 1)]];
}

# pragma RECIBE LAS ACCIONES DE LOS BOTONES DE LA VISTA DE CONSULTA EXTERNA
-(void)resingExternQueryViewButtonsPressed:(id)sender
{
    
    if ([sender tag] == 1) {  // Guardar array de Querys
        
        if (!backGrundLQHV.superview) {
            
        BOOL dbFound = NO;
        if (![useDatabaseTxt.text isEqualToString:@""]) {
            
            for (int i = 0; i < [arrayDataBase count]; i++) {
                
                if ([useDatabaseTxt.text isEqualToString:[arrayDataBase objectAtIndex:i]]) {
                    
                    if ([recentQuerys count] > 0) {
                     
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Query's history" message:@"Insert the query's history name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
                        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                        [alert setTag:16];
                        [alert show];
                    }
                    else
                    {
                        [self createAlertWithTitle:@"No data to save" Message:@"You have not made any consult." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
                    }
                    
                    dbFound = YES;
                    break;
                }
            }
            if (dbFound == NO) {
                
                [self createAlertWithTitle:@"Not match" Message:@"The current data base do not exist." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
            }
        }
        else
        {
            [self createAlertWithTitle:@"Not match" Message:@"You do not set the used extern data base." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
        
        }
    }
    else if ([sender tag] == 2)  // Boton: Cargar array de Querys
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Query statements and results" message:@"Load the querys or results save previously." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Query history",@"Query results", nil];
        [alert setTag:19];
        [alert show];
        
    }
    else if ([sender tag] == 3)  // Boton actualizar, interno del view LoadQueryHistoryView
    {
        [self processBuildingQueryHistoryLinkAndSetInView:loadQueryHistoryView]; // Construyendo los enlaces de los archivos (query) guardados
    }
    else if ([sender tag] == 4) // Boton cerrar, interno del view LoadQueryHistoryView
    {
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.3];
        [backGrundLQHV setAlpha:0.0];
        [loadQueryHistoryView setAlpha:0.0];
        [recentQueryScroll setAlpha:1.0];
        [UIView commitAnimations];
        
        [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(removeLoadQueryView) userInfo:nil repeats:NO];
    }
    else if ([sender tag] == 5)  // Boton actualizar, interno del view LoadQueryResultView
    {
        [self processBuildingQueryResultsLinkAndSetInView:loadQueryHistoryView]; // Construyendo los enlaces de los archivos (resultados de las consultas)
    }
}

#pragma CONSTRUYE LOS ENLACES DEL CONJUNTO DE QUERYS GUARDADOS
-(void)processBuildingQueryHistoryLinkAndSetInView:(UIView *)loadQueryView
{
    [queryHistoryLoadScroll removeFromSuperview];
    
    queryHistoryLoadScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, loadQueryView.frame.size.width, loadQueryView.frame.size.height - 80)];
    [queryHistoryLoadScroll setBackgroundColor:[UIColor clearColor]];
    [loadQueryView addSubview:queryHistoryLoadScroll];
    
    [querysLoaded removeAllObjects];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    BOOL found = NO;
    
    for (int c = 0; c < [arrayDataBase count]; c++) {
        
        if ([dbNameTxt.text isEqualToString:[arrayDataBase objectAtIndex:c]]) { // Busca el nombre de la bd en el array de base de datos
            
            for (int i = 0; i < [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@/%@",oneDataDirPath,dbNameTxt.text,queryFolderName] error:nil] count]; i++) {
                
                [array addObject:[[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@/%@",oneDataDirPath,dbNameTxt.text,queryFolderName] error:nil] objectAtIndex:i]];
                
                NSInteger Ypos = (((40) ) * ([array count] - 1));
                
                UIButton *queryBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, Ypos, 50, 40)];
                [queryBtn setTitle:[NSString stringWithFormat:@"%i) %@",(i + 1),[array objectAtIndex:i]] forState:UIControlStateNormal];
                [queryBtn setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
                [queryBtn.titleLabel setFont:[UIFont fontWithName:@"Heiti TC" size:13]];
                [queryBtn sizeToFit];
                [queryBtn setTag:i];
                [queryBtn addTarget:self action:@selector(loadQueryFromArrayWithTag:) forControlEvents:UIControlEventTouchUpInside];
                [queryHistoryLoadScroll addSubview:queryBtn];
                
                [queryHistoryLoadScroll setContentSize:CGSizeMake(0, Ypos + 40)];
            }
            found = YES;
            break;
        }
    }
    
    if (found == NO) {
        
        [self createAlertWithTitle:@"Not match" Message:@"The current data base do not exist." CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
    }
    else
    {
        querysLoaded = array; // Nombre del archivo cargado
    }
}

# pragma CONSTRUYE LOS ENLACES DEL CONJUNTO DE RESULTADOS DE LAS CONSULTAS
-(void)processBuildingQueryResultsLinkAndSetInView:(UIView *)loadQueryView
{
    [queryHistoryLoadScroll removeFromSuperview];
    
    queryHistoryLoadScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, loadQueryView.frame.size.width, loadQueryView.frame.size.height - 80)];
    [queryHistoryLoadScroll setBackgroundColor:[UIColor clearColor]];
    [loadQueryView addSubview:queryHistoryLoadScroll];
    
    [querysLoaded removeAllObjects];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
            
        for (int i = 0; i < [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,queryResultsFolderName] error:nil] count]; i++) {
                
            [array addObject:[[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,queryResultsFolderName] error:nil] objectAtIndex:i]];
                
            NSInteger Ypos = (((40) ) * ([array count] - 1));
                
            UIButton *queryBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, Ypos, 50, 40)];
            [queryBtn setTitle:[NSString stringWithFormat:@"%i) %@",(i + 1),[array objectAtIndex:i]] forState:UIControlStateNormal];
            [queryBtn setTitleColor:normalStateTableInternalBtnColor forState:UIControlStateNormal];
            [queryBtn.titleLabel setFont:[UIFont fontWithName:@"Heiti TC" size:13]];
            [queryBtn sizeToFit];
            [queryBtn setTag:i];
            [queryBtn addTarget:self action:@selector(getQueryResultName:) forControlEvents:UIControlEventTouchUpInside];
            [queryHistoryLoadScroll addSubview:queryBtn];
            
            [queryHistoryLoadScroll setContentSize:CGSizeMake(0, Ypos + 40)];
        }
    querysLoaded = array; // Nombre del archivo cargado
}

-(void)getQueryResultName:(id)sender
{
    [self loadQueryResultsFromRootPath:oneDataDirPath FileName:[[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",oneDataDirPath,queryResultsFolderName] error:nil] objectAtIndex:[sender tag]]];
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.3];
    [backGrundLQHV setAlpha:0.0];
    [loadQueryHistoryView setAlpha:0.0];
    [recentQueryScroll setAlpha:1.0];
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(removeLoadQueryView) userInfo:nil repeats:NO];
}

# pragma CARGA EL ARRAY DE QUERYS Y LOS COLOCA EN EL VIEW CORRESPONDIENTE
-(void)loadQueryFromArrayWithTag:(id)sender
{
    [recentQuerys removeAllObjects]; // Borrando el historial anterior
    [recentQueryScroll removeFromSuperview]; // Removiendo la vista historial.
    
    // Nueva vista para los historiales
    recentQueryScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, externConsultView.frame.size.width, 258)];
    [recentQueryScroll setBackgroundColor:[UIColor clearColor]];
    [recentQueryScroll setAlpha:0.0];
    [externConsultView addSubview:recentQueryScroll];
    
    
    for (int i = 0; i < [[self loadQueryUsedRecentlyFromPath:[NSString stringWithFormat:@"%@/%@/%@/%@",oneDataDirPath,dbNameTxt.text,queryFolderName,[querysLoaded objectAtIndex:[sender tag]]]] count]; i++) { // Construyendo los botones de enlace para cada historial.
        
        [self createNewHistoryConsultWithQuery:[[self loadQueryUsedRecentlyFromPath:[NSString stringWithFormat:@"%@/%@/%@/%@",oneDataDirPath,dbNameTxt.text,queryFolderName,[querysLoaded objectAtIndex:[sender tag]]]] objectAtIndex:i] CreateHistoricQueryButtons:YES WithFrame:CGRectMake(40, 0, recentQueryScroll.frame.size.width - 80, 40) InView:recentQueryScroll UseArrayQuery:recentQuerys];
    }
    
    [useDatabaseTxt setText:dbNameTxt.text];
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.3];
    [backGrundLQHV setAlpha:0.0];
    [loadQueryHistoryView setAlpha:0.0];
    [recentQueryScroll setAlpha:1.0];
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(removeLoadQueryView) userInfo:nil repeats:NO];
}

#define queryFolderName @"odxQueries"
#pragma GUARDA LAS CONSULTAS REALIZADAS
-(void)saveQueryUsedRecentlyFromArrayRecentQueries:(NSMutableArray *)recentQueries WithFileName:(NSString *)fileName
{
    NSString *queryFolderPath = [NSString stringWithFormat:@"%@/%@/%@",oneDataDirPath,tempDBname,queryFolderName]; // Ruta de la carpeta de queries guardados en la carpeta de la base de datos usada.
    NSString *queryPath = [NSString stringWithFormat:@"%@/%@",queryFolderPath,fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:queryFolderPath]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:queryFolderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
      BOOL success = [NSKeyedArchiver archiveRootObject:recentQueries toFile:queryPath];
    
        if (success == NO) {
            [self createAlertWithTitle:@"Information" Message:@"The file can not be saved" CancelBtnTitle:@"Accept" OtherBtnTitle:nil];
        }
}
#pragma CARGA LAS CONSULTAS REALIZADAS
-(NSMutableArray *)loadQueryUsedRecentlyFromPath:(NSString *)path
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

# pragma MUEVE DE POSICION EL CONSOLE VIEW
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (canMoveConsoleView == YES) {
        
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint point = [touch locationInView:tableConsoleView];
    
        [tableConsoleView setFrame:CGRectMake((tableConsoleView.frame.origin.x + point.x) - 20, (tableConsoleView.frame.origin.y + point.y) - 20, tableConsoleView.   frame.size.width, tableConsoleView.frame.size.height)];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    canMoveConsoleView = NO;
}

# pragma LIBERA LOS ARRAY ACTIVOS EN LA TABLA
-(void)releaseArrays
{
    [KeyTimerProcesing invalidate];
    [arrayField removeAllObjects];
    [arrayDataField removeAllObjects];
    [arrayOBfieldNames removeAllObjects];
    [arrayOBNumRows removeAllObjects];
    [arrayDataFound removeAllObjects];
    [arrayBtnSheet removeAllObjects];
    [arrayDataSheet removeAllObjects];
    [arrayColorFieldDataFound removeAllObjects];
    [arrayFieldNameQueryResult removeAllObjects];
    [arraydataQueryResult removeAllObjects];
    [arrayKeyBoardFieldType removeAllObjects];
    [arrayContentFromTableSheetRoot removeAllObjects];
    [arrayTableMetadata removeAllObjects];
    [arrayTablePass removeAllObjects];
    [recentQuerys removeAllObjects];
    [arrayTextFieldSelectAssistant removeAllObjects];
    [arrayTextFieldInsertAssistant removeAllObjects];
    [arrayClearTextFieldButtons removeAllObjects];
}
-(void)deallocObjects
{
    if ([ModeGraphORConsol isEqualToString:graphicsTableMode] || [ModeGraphORConsol isEqualToString:consoleTableMode]) {
        
        // Going back from table
        [self releaseArrays];
        [titleBar setText:@"Data bases"];
        SheetPath = @""; // No hay ninguna hoja de la tabla disponible
        
        [self verifyAppDirectory];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.4];
        [viewTableContainer setFrame:CGRectMake(1024, 0, 1024, 768)];
        [UIView commitAnimations];
        
        [MainView setFrame:CGRectMake(-30, 0, 1024, 768)];
        [UIView beginAnimations:NULL context:NULL];   // Animacion view principal
        [UIView setAnimationDuration:0.5];
        [MainView setFrame:CGRectMake(0, 0, 1024, 768)];
        [UIView commitAnimations];
        
        [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(removeTable) userInfo:nil repeats:NO];
        
    }
    else if ([ModeGraphORConsol isEqualToString:externConsultTableMode])
    {
        [self DataBases];
    }
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self.view layoutIfNeeded];
    self.canDisplayBannerAds = YES;
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.5];
    [bannerView setFrame:CGRectMake((self.view.bounds.size.width / 2) - 160, MainDBView.frame.size.height - 50, 320, 50)];
    [UIView commitAnimations];
    
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self.view layoutIfNeeded];
    self.canDisplayBannerAds = NO;
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.5];
    [bannerView setFrame:CGRectMake((self.view.bounds.size.width / 2) - 160, MainDBView.frame.size.height + 50, 320, 50)];
    
    [UIView commitAnimations];
}

-(void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd
{
    
}

-(void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd
{
}

-(void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd
{
}

-(void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self deallocObjects];
    // Dispose of any resources that can be recreated.
}

@end
