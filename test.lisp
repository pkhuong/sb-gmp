(defpackage :sb-gmp-test (:use "COMMON-LISP" :it.bese.fiveam))

(in-package :sb-gmp-test)

(def-suite sb-gmp-suite :description "Unit tests for the GMP lib interface.")

(in-suite sb-gmp-suite)

(defparameter *state* (sb-gmp:make-gmp-rstate))
(sb-gmp:rand-seed *state* 1234)

(defmacro defgenerator (name arguments &body body)
  `(defun ,name ,arguments
     (lambda () ,@body)))

(defgenerator gen-mpz (&key (limbs 5))
  (sb-gmp:random-bitcount *state* (* limbs sb-vm:n-word-bits)))

(test mpz-add "Test the mpz-add function"
  (sb-gmp:rand-seed *state* 1234)
  (dotimes (i 5)
    (let ((limbs (+ (random #xFFFFF) 2)))
      (for-all ((neg-a (gen-integer :min 0 :max 1))
                (neg-b (gen-integer :min 0 :max 1))
                (a (gen-mpz :limbs limbs))
                (b (gen-mpz :limbs limbs)))
        (let ((ta (if (zerop neg-a) a (- a)))
              (tb (if (zerop neg-b) b (- b))))
          (is (= (+ ta tb)
                 (sb-gmp:mpz-add ta tb))))))))

(test mpz-sub "Test the mpz-sub function"
  (sb-gmp:rand-seed *state* 1234)
  (dotimes (i 5)
    (let ((limbs (+ (random #x1FFFF) 2)))
      (for-all ((neg-a (gen-integer :min 0 :max 1))
                (neg-b (gen-integer :min 0 :max 1))
                (a (gen-mpz :limbs limbs))
                (b (gen-mpz :limbs limbs)))
        (let ((ta (if (zerop neg-a) a (- a)))
              (tb (if (zerop neg-b) b (- b))))
          (is (= (- ta tb)
                 (sb-gmp:mpz-sub ta tb))))))))

(test mpz-mul "Test the mpz-mul function"
  (sb-gmp:rand-seed *state* 1234)
  (dotimes (i 5)
    (let ((limbs (+ (random #x253F) 2)))
      (for-all ((neg-a (gen-integer :min 0 :max 1))
                (neg-b (gen-integer :min 0 :max 1))
                (a (gen-mpz :limbs limbs))
                (b (gen-mpz :limbs limbs)))
        (let ((ta (if (zerop neg-a) a (- a)))
              (tb (if (zerop neg-b) b (- b))))
          (is (= (* ta tb)
                 (sb-gmp:mpz-mul ta tb))))))))

(test mpz-truncate "Test the mpz-tdiv function"
  (sb-gmp:rand-seed *state* 1234)
  (dotimes (i 5)
    (let ((limbs (+ (random #x253F) 2)))
      (for-all ((neg-a (gen-integer :min 0 :max 1))
                (neg-b (gen-integer :min 0 :max 1))
                (a (gen-mpz :limbs limbs))
                (b (gen-mpz :limbs limbs)))
        (let ((ta (if (zerop neg-a) a (- a)))
              (tb (if (zerop neg-b) b (- b))))
          (multiple-value-bind (ld lr)
              (truncate ta tb)
            (multiple-value-bind (gd gr)
                (sb-gmp:mpz-tdiv ta tb)
              (is (and (= ld gd)
                       (= lr gr))))))))))

(test mpz-floor "Test the mpz-fdiv function"
  (sb-gmp:rand-seed *state* 1234)
  (dotimes (i 5)
    (let ((limbs (+ (random #x253F) 2)))
      (for-all ((neg-a (gen-integer :min 0 :max 1))
                (neg-b (gen-integer :min 0 :max 1))
                (a (gen-mpz :limbs limbs))
                (b (gen-mpz :limbs limbs)))
        (let ((ta (if (zerop neg-a) a (- a)))
              (tb (if (zerop neg-b) b (- b))))
          (multiple-value-bind (ld lr)
              (floor ta tb)
            (multiple-value-bind (gd gr)
                (sb-gmp:mpz-fdiv ta tb)
              (is (and (= ld gd)
                       (= lr gr))))))))))

(test mpz-ceiling "Test the mpz-cdiv function"
  (sb-gmp:rand-seed *state* 1234)
  (dotimes (i 5)
    (let ((limbs (+ (random #x253F) 2)))
      (for-all ((neg-a (gen-integer :min 0 :max 1))
                (neg-b (gen-integer :min 0 :max 1))
                (a (gen-mpz :limbs limbs))
                (b (gen-mpz :limbs limbs)))
        (let ((ta (if (zerop neg-a) a (- a)))
              (tb (if (zerop neg-b) b (- b))))
          (multiple-value-bind (ld lr)
              (ceiling ta tb)
            (multiple-value-bind (gd gr)
                (sb-gmp:mpz-cdiv ta tb)
              (is (and (= ld gd)
                       (= lr gr))))))))))

(test mpz-gcd "Test the mpz-gcd function"
  (sb-gmp:rand-seed *state* 1234)
  (dotimes (i 5)
    (let ((limbs (+ (random #x253F) 2)))
      (for-all ((neg-a (gen-integer :min 0 :max 1))
                (neg-b (gen-integer :min 0 :max 1))
                (a (gen-mpz :limbs limbs))
                (b (gen-mpz :limbs limbs)))
        (let ((ta (if (zerop neg-a) a (- a)))
              (tb (if (zerop neg-b) b (- b))))
          (is (= (gcd ta tb)
                 (sb-gmp:mpz-gcd ta tb))))))))

(test mpz-lcm "Test the mpz-lcm function"
  (sb-gmp:rand-seed *state* 1234)
  (dotimes (i 5)
    (let ((limbs (+ (random #x253F) 2)))
      (for-all ((neg-a (gen-integer :min 0 :max 1))
                (neg-b (gen-integer :min 0 :max 1))
                (a (gen-mpz :limbs limbs))
                (b (gen-mpz :limbs limbs)))
        (let ((ta (if (zerop neg-a) a (- a)))
              (tb (if (zerop neg-b) b (- b))))
          (is (= (lcm ta tb)
                 (sb-gmp:mpz-lcm ta tb))))))))

(test mpz-isqrt "Test the mpz-isqrt function"
  (sb-gmp:rand-seed *state* 1234)
  (dotimes (i 5)
    (let ((limbs (+ (random #x253F) 2)))
      (for-all ((a (gen-mpz :limbs limbs)))
        (is (= (isqrt a)
               (sb-gmp:mpz-sqrt a)))))))

(test mpz-mod "Test the mpz-mod function"
  (sb-gmp:rand-seed *state* 1234)
  (dotimes (i 5)
    (let ((limbs (1+ (random #x253F))))
      (for-all ((neg-a (gen-integer :min 0 :max 1))
                (neg-b (gen-integer :min 0 :max 1))
                (a (gen-mpz :limbs limbs))
                (b (gen-mpz :limbs limbs)))
        (let ((ta (if (zerop neg-a) a (- a)))
              (tb (if (zerop neg-b) b (- b))))
          (is (= (mod ta (abs tb))
                 (sb-gmp:mpz-mod ta tb))))))))

(test mpz-powm "Test the mpz-powm function"
  (sb-gmp:rand-seed *state* 1234)
  (dotimes (i 5)
    (let ((limbs (1+ (random #x125))))
      (for-all ((neg-a (gen-integer :min 0 :max 1))
                (a (gen-mpz :limbs limbs))
                (m (gen-mpz :limbs (ceiling limbs 2))))
        (let ((e (sb-bignum:make-small-bignum (1+ (random 40))))
              (ta (sb-gmp::bassert (if (zerop neg-a) a (- a)))))
          (is (= (mod (expt ta e) m)
                 (sb-gmp:mpz-powm ta e m))))))))

(test fixed-bugs "Tests for found bugs"
  (is (= (+ #x7FFFFFFFFFFFFFFF #x7FFFFFFFFFFFFFFF)
         (sb-gmp:mpz-add #x7FFFFFFFFFFFFFFF #x7FFFFFFFFFFFFFFF)))
  (let ((a 30951488519636377404900619671461408624764773310745985021994671444676860083493)
        (b 200662724990805535745252242839121922075))
    (multiple-value-bind (ld lr)
        (truncate a b)
      (multiple-value-bind (gd gr)
          (sb-gmp:mpz-tdiv a b)
        (is (and (= ld gd)
                 (= lr gr))))))
  (let ((a 320613729464106236061704728914573914390)
        (b -285049280629101090500613812618405407883))
    (multiple-value-bind (ld lr)
        (truncate a b)
      (multiple-value-bind (gd gr)
          (sb-gmp:mpz-tdiv a b)
        (is (and (= ld gd)
                 (= lr gr)))))))

(test mpz-nextprime "Test the mpz-nextprime/mpz-probably-prime-p function"
  (sb-gmp:rand-seed *state* 6234)
  (let ((limbs (1+ (random #x2F))))
    (for-all ((a (gen-mpz :limbs limbs)))
      (let ((p (sb-gmp:mpz-nextprime a)))
        (is (>= p a))
        (is (> (sb-gmp:mpz-probably-prime-p p) 0))))))

(test mpq-add "Test the mpq-add function"
  (sb-gmp:rand-seed *state* 1235)
  (dotimes (i 5)
    (let ((limbs (1+ (random #x3FF))))
      (for-all ((neg-a (gen-integer :min 0 :max 1))
                (neg-b (gen-integer :min 0 :max 1))
                (an (gen-mpz :limbs limbs))
                (ad (gen-mpz :limbs limbs))
                (bn (gen-mpz :limbs limbs))
                (bd (gen-mpz :limbs limbs)))
        (let ((tan (if (zerop neg-a) an (- an)))
              (tbn (if (zerop neg-b) bn (- bn))))
          (is (= (+ (/ tan ad) (/ tbn bd))
                 (sb-gmp:mpq-add (/ tan ad) (/ tbn bd)))))))))

(test mpq-sub "Test the mpq-sub function"
  (sb-gmp:rand-seed *state* 1235)
  (dotimes (i 5)
    (let ((limbs (1+ (random #x1FF))))
      (for-all ((neg-a (gen-integer :min 0 :max 1))
                (neg-b (gen-integer :min 0 :max 1))
                (an (gen-mpz :limbs limbs))
                (ad (gen-mpz :limbs limbs))
                (bn (gen-mpz :limbs limbs))
                (bd (gen-mpz :limbs limbs)))
        (let ((tan (if (zerop neg-a) an (- an)))
              (tbn (if (zerop neg-b) bn (- bn))))
          (is (= (- (/ tan ad) (/ tbn bd))
                 (sb-gmp:mpq-sub (/ tan ad) (/ tbn bd)))))))))

(test mpq-mul "Test the mpq-mul function"
  (sb-gmp:rand-seed *state* 6235)
  (dotimes (i 5)
    (let ((limbs (1+ (random #x5FF))))
      (for-all ((neg-a (gen-integer :min 0 :max 1))
                (neg-b (gen-integer :min 0 :max 1))
                (an (gen-mpz :limbs limbs))
                (ad (gen-mpz :limbs limbs))
                (bn (gen-mpz :limbs limbs))
                (bd (gen-mpz :limbs limbs)))
        (let ((tan (if (zerop neg-a) an (- an)))
              (tbn (if (zerop neg-b) bn (- bn))))
          (is (= (* (/ tan ad) (/ tbn bd))
                 (sb-gmp:mpq-mul (/ tan ad) (/ tbn bd)))))))))

(test mpq-div "Test the mpq-div function"
  (sb-gmp:rand-seed *state* 7235)
  (dotimes (i 5)
    (let ((limbs (1+ (random #x3FF))))
      (for-all ((neg-a (gen-integer :min 0 :max 1))
                (neg-b (gen-integer :min 0 :max 1))
                (an (gen-mpz :limbs limbs))
                (ad (gen-mpz :limbs limbs))
                (bn (gen-mpz :limbs limbs))
                (bd (gen-mpz :limbs limbs)))
        (let ((tan (if (zerop neg-a) an (- an)))
              (tbn (if (zerop neg-b) bn (- bn))))
          (is (= (/ (/ tan ad) (/ tbn bd))
                 (sb-gmp:mpq-div (/ tan ad) (/ tbn bd)))))))))

(test mpq-fail "Failure condition that was encountered during random testing (since resolved"
  (let ((an -13209053177313216326720071994575668671625946154424946979941042235025779609406066489124822060263741415731767909095535978759309084425875537563179113298131593713396775343237383458479781949550240630412701857403503233189863607072117930640826569182009206708933257720426339611012943709281997759942473045656872630494457723826960825086582617760738451841527423714294371807083373098832437021848589728037526905908672891882725056067884256042505048001986703119531737056795446226445664725837005863750123574298000192591001893057277178437857007262375095660896699217748352172606682055924706139632861269010372898134646451737590670614560649546844481697242528214535706357927544878674268030374370278308504509252394576207386344666818237571152429009824441574054780299582577801481767459654249022803191897258173315859493825673310472505293627476855369546650359583218498516377023038245685243868968780236437619483792036441607501402092965075649435802858970715108833831163596260720848064686538519339195183094001726352453705513582309597381501641400986633247524429625086995030279106454495104883103144972006136945504038625443714829393575431723477731391536529901691154731695666918250476276904458544458920225308813979815661628422015950374787964790294728431305560901981574526733321069031075413803807919559580147250764144945690106618011831706083014149915084399785240071376864007068579410836584583640124573636564525508781814067728494858869755462333538613864275409311494135416846021419052727382769669646774316183742088736319734577932969015168552780639091132865606483317081877017019863932502252092416408465358902183952810083840135676232857108681406486228546498252506817867584563688247332110215273151817829391150607426998926468854041744560970884608178439217990221993505915120441065973024578417594697614340421542869597391944892731436704363092556227861288542154533966853578546397006975240622959448425346779466724647279240015643799101159755851939673521288390733178144929994118609073425419299771438638154675479577257608964922414393526655389054776040890897127353109186990337860645391379224816579489224213787802841647588422060321741574667225867107935341545992758460567691834834677102164126543306712069736700806387259764413531457970954153801229449751018964914808807523738864401593622739672532046389168352737493963609733273138264236810210602108213237142407172633253427427858308191860601367964093868742916150428348086935533601815990061734949289335443255625406474502500919112688955733286467584667225159924898259902443424322015574285591785177463802961642299768433955323304169824647179428285450887144401989305402699455358336862489956755941197154511191311114593457064024159546112615698065878019110371636625550987691920666797008128403458483365368131571213824939808939703491750827705258225332786724552178963564173170124332641627169399852304611511887521527613858208776877706934034658839028986454686812721986441576582538345640083288494377295752136545030030378845647222986379656035835398148857804268458136966853832117064077363965110584146936510473620820871282616637067556761611627531675227320081363307277507286698878265502547270682650862708828)
        (ad 20513114107748916213404225865244788457074409421317268073736007022331351875833624862756219402282516605499234739123890210259042897848417665114604539868868273254948688298788998302213021613923064906756450800034198611450550412754819890990174752374167903316805361554027498760235600729993563831298333173441094727731923224830092028024856604134356448524792713778602056165546782663297074097079284342477853104853964497763641859184704167439137864700572855254893938640443507173796307557848785066207502084190070941243677848148415872970426984112227143138388781146980391816967852643014559749964089362445213740678445781520407345416931182699041155590319696207409023305181829071577033026467781464157778708535067535410514618107828410799078854809043994182182513891242966598128605638721171207590595334175915256179515795767729079909987621749163917687365458820366329459365528343025952159907952014278541741375614385752430254027787458039763962980148354021017595711354474983444535795390727075604793582413720611425701009821061847193862993314927110707228039583968452336179043689984205243355533686106965429229843687723310570965586179382872671178881510560063890749790799969604375110656863922578399537470723920490589304812587620853690645052574500291509160991572359900940420724641176985308557030554912090272478685362502316357934024797972855044761873086094428264355950862436019798203732663793722180258524408701122357905680756259238827164553903541080614504438587683436150871685884268883283911854170592499833400902456121829220126566671137352815854372233474135278712361983897095540626421407462186513362543785344229962579231578886782545540253824395033344947140802911329621494871150797172785087252655178157292521158795162751736228321379594242640753289713774813788577182079164501873509243856938395077798238684195225086857610004547607931023719346097561632391139975815092002982975159546683160426362246955972077936658217594864092323585697829920668939829394800301107410233703599100424307946464487800029921136792727516126004924528206024989173681199190467183044174366289573226993387328796686353001262094065886677828612237553191296728467686124117645915020679885821098583880459512400005399643605438196485962638776350246725512917429760098432821130792531585302118917535837554162150451664904547053284426081154205894049283709132043472492948062433231732886890323081803717104257817546161455251910978584912564590124304484825003663209179656643588909568838436967306030449237270646752767124447743338839118234701364264756637068592181857304587935081380346741935676377777738000391654868635675482278059571682109768442900093568916953814629840854483385045234030286006852324973600582554130111693028897769906912575142665730244531455877465249521338449046855843855835695525125243807274003500298341019159598027990797824307900319150505057082890499198084718553708432933227009336155667500047178145987247945476571211248754056910790992752991755636297837275630733526771844363248887124090245941209079831661430017567282457161714201881877508564203445830784748962887859489164006718845423665056853294160573803367220078511760896875018875436265794666526797116713991)
        (bn 18679644232137694835773895789796935368277093319442347009882028895983636202845338609238192673627146497565928042387055224157574139050288826655862246758264677614448028402353844741710560974837728602947105854327615172777677807366701532505782053272007434767818839012955843675198432125954639704393332610481612266824735837213574122272690607379032167676488469612066394795256393456323115729874647307324022050094919570365558303290939751605851466337737809073009233406468650259124598268624411389241168196985092309722980787131179252290893559312026443285238855953743578446404260697683876718720243998070208963196110161880695659120258496298742068955177202297231221854713889514939341338710288466093793249620509478542499217270116943730534610528631414218420777365890198159419904789404544815594578693254741245950839290769417056174832288369376710235014676146147468633129018928427491168063325782948815792849178692928887382135434681729289287967337075439807692747252894555096464608468870770272306141894543939790457871582280905906502647124459402979133843083046084613148746238605877442222978217173864099311407377701093864103693585496264088046841197293166458333808109330897750695971436430929379693868141924159750578349474196528735831027022930710200698011465050411238305883665750989820947782615767690752174603656863655235695510372750031379950324783924993662562999898391005787288706074052766163310550368263948617871014791452525375381426803827826752927165103290925907171678884968925213591369800936425974016544201074162690808540744854897729680887261315804116938589922540061828019386378590167985023192456982368984194146169494610555807299338947249571398537979070473103314582346674210413883618845411747108357789193206528225060723206424692411535736636880124631856413786992405295584419830157311803942862853074313776159067194511528927928414266465879542622955788891440153638676754727239764508736989303091478159209924874227484028795818451610680606439970077540524099704206162370096870622410572956084155250617029486154870570966638812142456113480214174492723144414953252009715373131781710069274723880618136495090451070098583243662797572407241313286841653442689485898363388204083005649951198361398468612590147786690372977367193534838948182349778146464897378808482133163629825944522445704281495970890808554290254714873933391569033738861111337892983959660609734480992012993277433865997793175736326621314652898038483105812001022395450458749805256561238577572040146462804577251468325598886411516301289338452351467886537896065545021406988061091200941643057561971430385531845109791470909518930415984599441096465126692173387505995283866721562382544618237963718834045094760633539051908412566846285956073333799948712666521093676261861167303418973611709249741242454070021816184150635280988297097917463890986448016624789958062269731291092669270798993316373736592456861706792773261332823061122660874852391531335207185069468318947590952403786907139751917687296093870144147055137535538562666514450751236638639254714837540658351799195360032379598389809413531717309390498240542341409517870564609553438235694303893655478920111421329599854382059)
        (bd 35047375165067289478184579374088753519723409541358727851367833378045381161956857862822162664157407750114046088766861757768628361860450858550612162200604740528020549735526868301563450011458255876617372435581481413877626213584152958947512852610351865749619221182400335300981664095326585454825312297691968407481156213225240040259895631250587691435815407287057903383853149474327315762925358991507160427907888884554569193526587056400916286053773407408865362995781271043549911925410762585516917061851141429216498699036671966534807428201871680758644707869709055458345849760857447496997369459512430997600004647049262418108322920507202971361167434749566827221165629531524830063260150702915506513004140215619053251853221128227039573877830371056963496851061915005076713551938040426681835756484540822137833583839287273858119692954255679012880175954568099315917680559792168668290774115965992289930491245825501336418496149153195257486784214896251536902218095859878825175930104814002335186480516826697953970017283350762453123058826001074995827392758721263396789788171838854949995547275268946535021565360713052629801500761448894400314861354423310859391743686807240892514171117787583263534162869357320748877744731428554325911583092674254089309526792474206410123702980303052860969897399493933015372688281452770610307341291480264049601427255610847963613178959192364378622499160842253921207881626181581709855849432538739896839132656376924833085425334004208124463768334575132431712512267775703706491862340888727839505443433268529379987084625482496093787809074752688019948611710332687765927010511936393170622967393012885553949858840148946705853974220230333552679372649812288028205467991322591700053013007905861724568610606853496128017958814314450986832892988026223481899589331851816885128871124803692166197269829726785503967919268160500701435937831624617814093029450809869946138434889833384333032268194378347437153894298364527885530000640988674907753972046462491022827738005865076839138904283740722398989182880398823501150929948982395291592901295075465416607929007655790650722355676164182368279922022441635530379579396127841519540366765299138907464310936858631412869302144760544631722698855436241594426632799148068619791910004407651630129367721152620976432342245466252584851082147635414151337510386583270139031454475785430451613760410780963926233601058128946480944715083701501658239619004129521741582609884569752285592082229894073389739632290612979527960898956998537733110196762265428813645010248053457222143316651370707088803028348532186655314492324589438375979080705908912991001132757969685814749516624261196677521777688416066667857217162155509052884746889529221826307232465665939634819692653774644615752505524321373928021711308907637490611431718655229495166013973268494159392003260853439666992720242593681536443289086106672585130316509972729860170549253311425331179571717512946796316828551789499616649200744710228301066546180726362338960578934089254316390186365586939632431422116920095304572927553904681045284800605022616383305331739050601840250168653669981271907611676558111666927724598500621490620608))
    (is (= (+ (/ an ad) (/ bn bd))
           (sb-gmp:mpq-add (/ an ad) (/ bn bd))))))
