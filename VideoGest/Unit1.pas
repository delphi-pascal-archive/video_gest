unit Unit1;
{###############################################################################
#                                                                              #
#   PETITE APPLICATION POUR GERER UNE VIDEOTHEQUE                              #
#     OPTIONS A L'OUVERURE (DANS L'ORDRE DE PRIORITE)                          #
#       - AVEC UN PASSAGE DE PARAMETRE (n° 1) : NOM DE FICHIER                 #
#       - REOUVERTURE DU DERNIER FICHIER OUVERT                                #
#              LE FICHIER EST ENREGISTE DANS UN FICHIER DE CONFIGURATION       #
#              SE TROUVANT DANS LE MÊME REPERTOIRE QUE L'APPLICATION           #
#       - OUVERTURE DU FICHIER SE TROUVANT DANS LE MÊME REPERTOIRE QUE         #
#         L'APPLICATION. SI PLUSIEURS FICHIERS SONT TROUVES, UNE LISTE DE      #
#         FICHIER PERMET DE SELECTIONNER CELUI QUE L'ON SOUHAITE               #
#                                                                              #
################################################################################
#                                                                              #
#   UTILISATION DU DAGNDROP DE TEXTE EXTERNE A L'APPLICATION, INFORMATIONS     #
#    TROUVEES SUR CETTE PAGE :                                                 #
#       http://mgc99.free.fr/Delphiproc.htm                                    #                                       #
#                                                                              #
################################################################################
#                                                                              #
#    EN CE QUI CONCERNE LA BASE DE DONNEES, UTILISATION DE "MLB2"(MyLittleBase)#
#    DONT LES SOURCES PEUVENT ÊTRE TROUVEES A CETTE ADRESSE :                  #
#      http://mylittlebase.free.fr/                                            #
#                                                                              #
#    SOURCES FOURNIS DANS "MLBV202.ZIP"                                        # 
###############################################################################}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, mlbc, Buttons, ImgList, Menus, printers,
  Unit2, Unit3, Types, Clipbrd, inifiles,ComObj,OleCtnrs,ActiveX, Shellapi;

type
  TForm1 = class(TForm,IDropTarget)
    Panel1: TPanel;
    Tab: TTabControl;
    lst: TTreeView;
    Fiche: TPanel;
    E_Titre: TLabeledEdit;
    E_Supp: TComboBox;
    Label1: TLabel;
    E_genre: TComboBox;
    Label2: TLabel;
    E_Acteur: TMemo;
    annul: TBitBtn;
    Enregistre: TBitBtn;
    Panel3: TPanel;
    VoirTablo: TBitBtn;
    Openf: TOpenDialog;
    base: TMlbc;
    E_Date: TLabeledEdit;
    E_Realis: TLabeledEdit;
    E_Pret: TLabeledEdit;
    SaveD: TSaveDialog;
    Sauver: TBitBtn;
    Menu_Img: TImageList;
    Tab_Img: TImageList;
    menu_Lst: TPopupMenu;
    Nouv_F: TMenuItem;
    Mod_F: TMenuItem;
    Sup_F: TMenuItem;
    N1: TMenuItem;
    Nouv_B: TMenuItem;
    Ouv_B: TMenuItem;
    Save_B: TMenuItem;
    SaveSous_B: TMenuItem;
    N2: TMenuItem;
    Quitter1: TMenuItem;
    N3: TMenuItem;
    VoirleTableau: TMenuItem;
    Imprimer: TMenuItem;
    Miseenpage: TMenuItem;
    Image_Lst: TImageList;
    PrintD: TPrintDialog;
    ListingComplet1: TMenuItem;
    Listedestitres1: TMenuItem;
    Fiche1: TPanel;
    Fiche2: TPanel;
    Label4: TLabel;
    RF: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure VoirTabloClick(Sender: TObject);
    procedure EnregistreClick(Sender: TObject);
    procedure TabChange(Sender: TObject);
    procedure SauverClick(Sender: TObject);
    procedure E_PretChange(Sender: TObject);
    procedure E_DateClick(Sender: TObject);
    procedure lstDblClick(Sender: TObject);
    procedure lstChange(Sender: TObject; Node: TTreeNode);
    procedure lstKeyPress(Sender: TObject; var Key: Char);
    procedure Quitter1Click(Sender: TObject);
    procedure Save_BClick(Sender: TObject);
    procedure SaveSous_BClick(Sender: TObject);
    procedure menu_LstPopup(Sender: TObject);
    procedure Ouv_BClick(Sender: TObject);
    procedure annulClick(Sender: TObject);
    procedure Sup_FClick(Sender: TObject);
    procedure E_TextChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Nouv_FClick(Sender: TObject);
    procedure ImprimerClick(Sender: TObject);
    procedure Nouv_BClick(Sender: TObject);
    procedure Listedestitres1Click(Sender: TObject);
    procedure lstCollapsed(Sender: TObject; Node: TTreeNode);
    procedure lstExpanded(Sender: TObject; Node: TTreeNode);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    F : TForm;
    I : TImage;
    B : TListBox;
    select : integer;
    Change : Boolean;
    Lst_Acteurs : TStringList;
    Lst_Realis : TStringList;
    M_Acteurs : TPopUpMenu;
    M_Realis : TPopUpMenu;
    Rep_App : string;
    Fichier : String;
    Function GetNodeWithText(S : String) : Integer;  // non utilisé mais gardé pour un future évollution
    Function GetNodeWithTextaslevel(S : String;  L : integer) : Integer;
    Function F_Liste(Lst : TStringList) : string;

    Procedure B_Dblclick(Sender : Tobject);

    Procedure MakeFormBar;

    Procedure lst_Act_Click(Sender : TObject);
    Procedure Act_Menu(Sender : TObject);
    Procedure Act_Couper(Sender : TObject);
    Procedure Act_Copier(Sender : TObject);
    Procedure Act_Coller(Sender : TObject);

    Procedure lst_Rea_Click(Sender : TObject);
    Procedure Rea_Menu(Sender : TObject);
    Procedure Rea_Couper(Sender : TObject);
    Procedure Rea_Copier(Sender : TObject);
    Procedure Rea_Coller(Sender : TObject);


    Procedure Make_Menus;
    Procedure NouvelleBase;
    Procedure OuvrirBase(F : String);
    Procedure SaveBase(F : String);
    Procedure Tri_Titre;
    Procedure Tri_Acteurs;
    Procedure Tri_Realis;
    Procedure Tri_Genre;
    Procedure Tri_Support;
    Procedure Tri_Pret;
    procedure affiche;

    Procedure Add_denier_Fichier;
    Procedure reouvrir(sender : Tobject);


    // Gestion du DragandDrop externe
    function DragEnter(const dataObj: IDataObject;grfKeyState: Longint; pt: TPoint;
                       var dwEffect: Longint): HResult; stdcall;
    function DragOver(grfKeyState: Longint; pt: TPoint;
                       var dwEffect: Longint): HResult; stdcall;
    function DragLeave: HResult; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint;
                       var dwEffect: Longint): HResult; stdcall;

    Function GetComponentIndex(pt : TPoint) : Int64;


  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation


{$R *.dfm}

// petite routine pour être certain que le répertoire se termine par "\"
function Confrep(R : string) : string;
begin
 if length(R) > 0 then
 if R[length(R)] = '\' then result := R
                       else Result := R + '\'
  else result := '';
end;

// Premet de trouver le premier noeud contenant le texte donné
Function TForm1.GetNodeWithText(S : String) : integer;
Var N : integer;
begin
 if lst.Items.Count = 0 then result := -1
 else begin
  N := 0;
  while (N < Lst.Items.Count) and (Lst.Items.Item[N].Text <> S) do inc(N);
  if Lst.Items.Item[N].Text = S then Result := Lst.Items.Item[N].AbsoluteIndex
                                else result := -1;
 end;
end;

// Premet de trouver le premier noeud contenant le texte donné à un niveau donné
Function TForm1.GetNodeWithTextaslevel(S : String;  L : integer) : Integer;
Var N : integer;
begin
 if lst.Items.Count = 0 then result := -1
 else begin
  N := 0;
  while (N < (Lst.Items.Count-1)) and not((Lst.Items.Item[N].Text = S)
     and (Lst.Items.Item[N].Level = L)) do inc(N);
  if (Lst.Items.Item[N].Text = S) and (Lst.Items.Item[N].Level = L)
    then Result := Lst.Items.Item[N].AbsoluteIndex
    else result := -1;
 end;
end;

// Permet de voir le tableau avec l'ensemble des données
procedure TForm1.VoirTabloClick(Sender: TObject);
begin
 with Form2 do
  begin
   Base.GoFirst;                             // on positionne sur la première fiche
   Grille.RowCount := Base.RowCount + 1;     // définition de la hauteur du tableau
   Grille.Cells[0,0] := '';                  // Saisie de la première ligne
   Grille.Cells[1,0] := 'Titre';
   Grille.Cells[2,0] := 'Genre';
   Grille.Cells[3,0] := 'Support';
   Grille.Cells[4,0] := 'Acteurs';
   Grille.Cells[5,0] := 'Réalisateur';
   Grille.Cells[6,0] := 'Pret';
   Grille.ColWidths[0] := 30;                // Définition de la largeur des colones
   Grille.ColWidths[1] := 150;
   Grille.ColWidths[2] := 70;
   Grille.ColWidths[3] := 70;
   Grille.ColWidths[4] := 120;
   Grille.ColWidths[5] := 120;
   Grille.ColWidths[6] := 120;
   while not Base.EndOfFile do              // on scanne l'ensemble de la base de données afin
    begin                                   // de l'afficher
     Grille.Cells[0,Base.GetCurrentRow] := inttostr(Base.GetCurrentRow);
     Grille.Cells[1,Base.GetCurrentRow] := Base.GetData('TITRE');
     Grille.Cells[2,Base.GetCurrentRow] := Base.GetData('GENRE');
     Grille.Cells[3,Base.GetCurrentRow] := Base.GetData('SUPPORT');
     Grille.Cells[4,Base.GetCurrentRow] := Base.GetData('ACTEURS');
     Grille.Cells[5,Base.GetCurrentRow] := Base.GetData('REALISATEUR');
     if length(Base.GetData('PRET')) = 0 then   // on inscrit le nom de la personne que emprunte
      Grille.Cells[6,Base.GetCurrentRow] := ''  // avec la date dans la même colone => insertion
     else                                       // du caractère #13
     Grille.Cells[6,Base.GetCurrentRow] := Base.GetData('PRET') + #13 +
                                           'Le ' + Base.GetData('DATEP');
     Base.GoNext; //passe à la fiche suivante
    end;
   if Base.RowCount > 1 then Showmodal; // affichage du tableau
  end;
end;

// permet d'afficher les informations de la fiche actuellement ouverte dans la B-D
procedure Tform1.affiche;
begin
 E_titre.Text := base.GetData('TITRE');
 E_Supp.Text := base.GetData('SUPPORT');
 E_genre.Text := base.GetData('GENRE');
 E_Acteur.Lines.Text := base.GetData('ACTEURS');
 E_Realis.Text := base.GetData('REALISATEUR');
 E_Pret.Text := base.GetData('PRET');
 E_Date.Text := base.GetData('DATEP');
 E_date.Visible := length(E_Pret.Text) > 0;
end;

//****************************************************************
// Evenement pour la sélection d'un fichier dans une liste     ***
Procedure TForm1.B_Dblclick(Sender : Tobject);               //***
begin                                                        //***
 F.ModalResult := mrOk;                                      //***
end;                                                         //***
                                                             //***
// affiche la liste données par "Lst" et renvoi celle qui      ***
//est sélectionnée                                             ***
// Petit exemple de création dynamique                         ***
Function Tform1.F_Liste(Lst : TStringList) : string;         //***
begin                                                        //***
 F := TForm.Create(nil);                                     //***
 F.Visible := False;                                         //***
 F.ClientWidth := 100;                                       //***
 F.ClientHeight := 100;                                      //***
 F.BorderStyle := bsToolWindow;                              //***
 f.BorderIcons := [];                                        //***
 f.Caption := '';                                            //***
 F.Position := poscreencenter;                               //***
 F.FormStyle := fsStayOnTop;                                 //***
 B := TListBox.Create(nil);                                  //***
 B.Parent := F;                                              //***
 B.Align := alclient;                                        //***
 B.Items.Assign(Lst);                                        //***
 B.MultiSelect := False;                                     //***
 B.OnDblClick := B_Dblclick; // affecte un évenement au DblClick sur B
 F.ShowModal;                                                //***
 if B.ItemIndex <> -1 then                                   //***
   Result := B.Items.Strings[B.ItemIndex]                    //***
   else result := '';                                        //***
 B.Free; F.Free;                                             //***
end;                                                         //***
//****************************************************************

//****************************************************************
// Procedure associées au menu des acteurs                     ***
// Exécution d'évennement                                      ***
Procedure TForm1.lst_Act_Click(Sender : TObject);            //***
Begin                                                        //***
 E_Acteur.Lines.Add((Sender as TMenuItem).Caption);          //***
end;                                                         //***
                                                             //***
Procedure Tform1.Act_Menu(Sender : TObject);                 //***
begin                                                        //***
 M_Acteurs.Items.Items[0].Enabled := E_Acteur.SelLength > 0; //***
 M_Acteurs.Items.Items[1].Enabled := E_Acteur.SelLength > 0; //***
 M_Acteurs.Items.Items[0].Enabled := Length(Clipboard.AsText) > 0;
end;                                                         //***
                                                             //***
Procedure TForm1.Act_Couper(Sender : TObject);               //***
Begin                                                        //***
 Clipboard.AsText := E_Acteur.SelText;                       //***
 E_Acteur.SelText := '';                                     //***
end;                                                         //***
Procedure TForm1.Act_Copier(Sender : TObject);               //***
Begin                                                        //***
 Clipboard.AsText := E_Acteur.SelText;                       //***
end;                                                         //***
                                                             //***
Procedure TForm1.Act_Coller(Sender : TObject);               //***
Begin                                                        //***
 E_Acteur.SelText := Clipboard.AsText;                       //***
end;                                                         //***
//****************************************************************
// Procedure associées au menu des réalisateurs                ***
// Exécution d'évennement                                      ***
Procedure TForm1.lst_Rea_Click(Sender : TObject);            //***
begin                                                        //***
 E_Realis.Text := (Sender as TMenuItem).Caption;             //***
end;                                                         //***
                                                             //***
Procedure Tform1.Rea_Menu(Sender : TObject);                 //***
begin                                                        //***
 M_realis.Items.Items[0].Enabled := E_realis.SelLength > 0;  //***
 M_realis.Items.Items[1].Enabled := E_realis.SelLength > 0;  //***
 M_realis.Items.Items[0].Enabled := Length(Clipboard.AsText) > 0;
end;                                                         //***
                                                             //***
Procedure Tform1.Rea_Couper(Sender : TObject);               //***
Begin                                                        //***
 Clipboard.AsText := E_realis.SelText;                       //***
 E_realis.SelText := '';                                     //***
end;                                                         //***
Procedure Tform1.Rea_Copier(Sender : TObject);               //***
Begin                                                        //***
 Clipboard.AsText := E_realis.SelText;                       //***
end;                                                         //***
                                                             //***
Procedure Tform1.Rea_Coller(Sender : TObject);               //***
Begin                                                        //***
 E_realis.SelText := Clipboard.AsText;                       //***
end;                                                         //***
//****************************************************************

{*******************************************************************************
***                                                                          ***
***  Création d'une nouvelle base de données                                 ***
***                                                                          ***
*******************************************************************************}
Procedure TForm1.NouvelleBase;
Var ok : boolean;
Begin

 if Change then // Vérification si le ficher actuel a été modifié
  case messagedlg('la base de donnée n''a pas été sauvegarder, voullez vous le faire maintenant ?',
                 mtinformation,mbyesnocancel,-1) of
    mrYes : begin            // suvegarde du fichier déja ouvert
             SaveBase(Fichier);
            end;
    mrNo  : ok := True;     // Pas de sauvegarde
    mrCancel : ok := False; // annulation
   end
 else ok := true;

 if Ok then
  begin
   Base.Clear;                  // remise à zéro de la base de données
   Base.Init;
   Base.AddField('TITRE');      // inscription des différents champs
   Base.AddField('SUPPORT');
   Base.AddField('GENRE');
   Base.AddField('ACTEURS');
   Base.AddField('REALISATEUR');
   Base.AddField('PRET');
   Base.AddField('DATEP');
   Lst.Items.Clear;             // toutes les visu sont effacées
   Tab.TabIndex := 0;
   E_Titre.Text := '';
   E_Supp.Text := '';
   E_Genre.Text := '';
   E_Realis.Text := '';
   E_Acteur.Lines.Clear;
   E_Pret.Text := '';
   E_Date.Visible := False;
   E_Date.Text := '';
   select := -1;
   Fichier := '';
   change := False;
   Caption := 'Nouveau Fichier';
   lst.Items.Clear;

   Fiche1.Enabled := False;
   Fiche2.Enabled := False;
   E_Acteur.ReadOnly := True;
  end;
end;

{*******************************************************************************
***                                                                          ***
***  Ouverture de la base de données                                         ***
***                                                                          ***
*******************************************************************************}
Procedure TForm1.OuvrirBase(F : String);
Var BB : TMlbc;
    Bon : boolean;
    N : Integer;
    L : TStringList;
Begin
 BB := TMlbc.Create(self);
 BB.LoadFromFile(F);
 try
  if BB.FieldCount = 7 then // Vérification si la Base de données est compatible
   begin
    Bon := True;
    if uppercase(BB.FieldName[1]) <> 'TITRE'       then Bon := False;
    if uppercase(BB.FieldName[2]) <> 'SUPPORT'     then Bon := False;
    if uppercase(BB.FieldName[3]) <> 'GENRE'       then Bon := False;
    if uppercase(BB.FieldName[4]) <> 'ACTEURS'     then Bon := False;
    if uppercase(BB.FieldName[5]) <> 'REALISATEUR' then Bon := False;
    if uppercase(BB.FieldName[6]) <> 'PRET'        then Bon := False;
    if uppercase(BB.FieldName[7]) <> 'DATEP'       then Bon := False;
   end else bon := False;
 finally BB.Free; end;

 if Bon then
  begin
   L := TStringList.Create;
   Base.LoadFromFile(F);
   Fichier := F;
   Base.GoFirst;
   while not Base.EndOfFile do // Création des différentes listes => Genres / Supports / Réalisateurs / Acteurs
    begin                      // on utilise uniquement les infos contenues dans Base de données
     if (E_Genre.Items.IndexOf(Base.GetData('GENRE')) = -1 ) and (length(Base.GetData('GENRE'))>0)then
      E_Genre.Items.Add(Base.GetData('GENRE'));
     if (E_Supp.Items.IndexOf(Base.GetData('SUPPORT')) = -1) and (length(Base.GetData('SUPPORT'))>0) then
      E_Supp.Items.Add(Base.GetData('SUPPORT'));
     if (Lst_Realis.IndexOf(Base.GetData('REALISATEUR')) = -1) and (length(Base.GetData('REALISATEUR'))>0) then
      Lst_Realis.Add(Base.GetData('REALISATEUR'));

     L.Text := Base.GetData('ACTEURS');
     N := 0;
     While N < L.Count do
      begin
       if Lst_Acteurs.IndexOf(L.Strings[N]) = -1 then
        Lst_Acteurs.Add(L.Strings[N]);
       inc(N);
      end;
     Base.GoNext;
    end;
   L.Free;

   change := False;
   if Tab.TabIndex = 0 then Tri_Titre
   else Tab.TabIndex := 0;
   Caption := Fichier;
   Add_denier_Fichier;
  end else
  begin
   messageDlg('Le fichier selectionné (' + extractfilename(F) + ') n''est pas compatible !',
              mtWarning,[mbOk],-1);
   Nouvellebase;
  end;
end;

{*******************************************************************************
***                                                                          ***
***  Sauvegarde de la base de données                                        ***
***                                                                          ***
*******************************************************************************}
Procedure Tform1.SaveBase(F : String);
Begin
 if F = '' then // si le fichier n'a pas de nom, ouverture de la boite de dialogue
  begin         // pour lui en affecter un
   if SaveD.Execute then
    begin
     Fichier := SaveD.FileName;
     if length(extractFileExt(Fichier)) < 1 then Fichier:= Fichier + '.vdo';
     Base.SaveToFile(Fichier);
     change := False;
    end else showmessage('Le fichier n''a pas été sauvegardé !!!');
  end else
   begin
    Base.SaveToFile(F);
    Add_denier_Fichier;
    Change := False;
   end;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
 // initialisation pour le DragnDrop externe
 OleInitialize(nil);
 OleCheck(RegisterDragDrop(Handle, Self));

 // initialisation des popupmenu acteurs et réalisateurs
 M_Acteurs := TPopUpMenu.Create(nil);
 M_Realis := TPopUpMenu.Create(nil);
 M_Acteurs.AutoHotkeys := maManual;
 M_Realis.AutoHotkeys := maManual;

 // initialisation des listes des acteurs et réalisateurs
 Lst_Acteurs := TStringList.Create;
 Lst_Realis := TStringList.Create;

 // initialisation de la variable contenant le répertoire de l'application
 rep_app := confrep(extractfilepath(paramstr(0)));

end;



procedure TForm1.FormShow(Sender: TObject);
Var F : TSearchRec;
    R : integer;
    L : TStringList;
    B : Boolean;
    C : TInifile;
begin
 if paramCount > 0 then // un parametre est passé => ouverture du fichier donné par le parametre
  begin
   SetCurrentDir(ExtractFilePath(paramstr(1)));
   Fichier := extractFilename(Paramstr(1));
   OuvrirBase(Fichier);
   B := False;
  end else
 if FileExists(Rep_app + 'videos.cfg') then // Recherche d'un fichier de configuration
  begin
   C := TInifile.Create(Rep_app + 'videos.cfg'); // ouverture du fichier de configuration
   try
    if C.ReadString('FICHIER','DERNIER','#1#2#3#4') = '#1#2#3#4' then
    B := True // il n'existe pas encore de fichier précédemment ouvert
    else begin
     Ouvrirbase(C.ReadString('FICHIER','DERNIER','')); // ouverture du fichier
     B := False;
    end;
   finally C.Free; end;
  end else B := True;

if b then // aucune des actions précédentes n'a permis l'ouverture d'un fichier
 begin
 R := findFirst(rep_app + '*.vdo',$3F,F);  // on Scanne le répertoire pour voir si il existe
 L := TStringList.Create;                  // un ou plusieurs fichier avec la bonne extention
 while R = 0 do
  begin
   L.Add(extractfilename(F.Name));
   R := FindNext(F);
  end;
 FindClose(F);
 if L.Count > 1 then      // plusieurs fichiers sont trouvés
  begin
   fichier := F_Liste(L); // on sélectionne le fichier à ouvrir (cf Ligne 281)
   if Fichier = '' then nouvelleBase
             else OuvrirBase(Fichier);
  end else
  if L.Count = 0 then NouvelleBase             // Pas de fichier trouvé => Création d'une nouvelle Base de données
                 else OuvrirBase(L.Strings[0]);// Un seul fichier trouvé => ouverture du fichier
 end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
if change then // Avant de quitter, on vérifie que la base de données est sauvezgardée
 case messageDlg('Voullez vous sauvegarder avant de quitter l''application ?',
                  mtConfirmation, mbyesnocancel,-1) of
    mrcancel : canclose := false;
    mrno     : canclose := true;
    mryes    : begin
               canclose := true;
               SaveBase(fichier);
              end;
 end;
end;

// Création dynamique d'une form pour y mettre une barre de progression
Procedure TForm1.MakeFormBar;
begin
 Enabled := False;
 F := TForm.Create(nil);
 F.BorderStyle := bsNone;
 F.ClientHeight := 30;
 F.ClientWidth := (Form1.ClientWidth * 2) div 3;
 F.Top := Form1.Top + (Form1.ClientHeight - 10) div 2;
 F.Left := Form1.Left + (Form1.ClientWidth - F.ClientWidth) div 2;
 F.visible := True;
 F.AlphaBlend := True;
 F.AlphaBlendValue := 200;

 I := TImage.Create(nil);
 I.Parent := F;
 I.Visible := true;
 I.Align := alnone;
 I.Top := 5;
 I.Left := 5;
 I.Width := F.ClientWidth - 10;
 I.Height := F.ClientHeight - 10;

 with I.Canvas do
  begin
   Pen.Width := 2;
   Pen.Color := 0;//$AA2222;
   Brush.Color := $FFDDEE;
   RoundRect(1,1,I.Width-3,I.Height-3,10,10);
   Pen.Style := psClear;
   Brush.Color := $00FF00;
  end;
 lst.Repaint;
 F.Repaint;
end;

//******************************************************************************
//              PROCEDURES DE TRI                                            ***
//******************************************************************************
// Tri Par Titre                                                             ***
//    les titres sont enregistés dans un noeud correspondant à la première   ***
//    lettre du titre                                                        ***
Procedure TForm1.Tri_Titre;                                                //***
Var C : Char; N : integer; S : String;                                     //***
begin                                                                      //***
 MakeFormBar;   // Création de la barre de progression (cf ligne 597)        ***
 Base.GoFirst;  // on positionne la base de données sur la première fiche    ***
 lst.Items.Clear;                                                          //***
 while not Base.EndOfFile do                                               //***
  begin                                                                    //***
   I.Canvas.RoundRect(2,2,((I.Width-4) div Base.RowCount) * (Base.GetCurrentRow + 1),I.ClientHeight - 4,10,10);
   S := Base.GetData('TITRE');                                             //***
   C := upcase(S[1]);                                                      //***
   S[1] := C;                                                              //***
   if not(C in ['A'..'Z']) then C := '#';                                  //***
   N := GetNodeWithTextasLevel(C,0);                                       //***
   if N = -1 then                                                          //***
   N := Lst.Items.AddFirst(nil,C).AbsoluteIndex;                           //***
   Lst.Items.Item[N].ImageIndex := 0;                                      //***
   with Lst.Items.AddChild(Lst.Items.Item[N],S) do                         //***
    begin                                                                  //***
     imageindex := 2;                                                      //***
     StateIndex := Base.GetCurrentRow;                                     //***
    end;                                                                   //***
   base.Gonext;                                                            //***
  end;                                                                     //***
 lst.AlphaSort;                                                            //***
 I.Free;                                                                   //***
 F.Free;                                                                   //***
 Enabled := true;                                                          //***
end;                                                                       //***
                                                                           //***
// Tri Par Acteurs                                                           ***
//    Les acteurs sont triés par ordre alphabétiques dans un noeud           ***
//    correspondant à la première lettre de l'acteur puis l'ensemble des     ***
//    des film sont mis dans chaques noeud d'acteur                          ***
Procedure TForm1.Tri_Acteurs;                                              //***
Var C : Char;                                                              //***
    M,N : integer;                                                         //***
    S : String;                                                            //***
    L : TStringList;                                                       //***
begin                                                                      //***
 MakeFormBar;                                                              //***
 Base.GoFirst;                                                             //***
 lst.Items.Clear;                                                          //***
 L := TStringList.Create;                                                  //***
 while not Base.EndOfFile do                                               //***
  begin                                                                    //***
   L.Clear;                                                                //***
   I.Canvas.RoundRect(2,2,((I.Width-4) div Base.RowCount) * (Base.GetCurrentRow + 1),I.ClientHeight - 4,10,10);
   I.Refresh;                                                              //***
   Application.ProcessMessages;                                            //***
   L.Text := Base.GetData('ACTEURS');                                      //***
   if L.Count = 0 then                                                     //***
    begin                                                                  //***
     N := GetNodeWithTextasLevel(' Sans Acteur',0);                        //***
     if N = -1 then                                                        //***
     N := Lst.Items.AddFirst(nil,' Sans Acteur').AbsoluteIndex;            //***
     with Lst.Items.AddChild(Lst.Items.Item[N],Base.GetData('TITRE')) do   //***
      StateIndex := Base.GetCurrentRow;                                    //***
    end else                                                               //***
    begin                                                                  //***
     while L.Count > 0 do                                                  //***
      begin                                                                //***
       S := L.Strings[0];                                                  //***
       C := upcase(S[1]);                                                  //***
       S[1] := C;                                                          //***
       if not(C in ['A'..'Z']) then C := '#';                              //***
       N := GetNodeWithTextasLevel(C,0);                                   //***
       if N = -1 then                                                      //***
       N := Lst.Items.AddFirst(nil,C).AbsoluteIndex;                       //***
       M := GetNodeWithTextasLevel(S,1);                                   //***
       if M = -1 then                                                      //***
       M := Lst.Items.AddChild(Lst.Items.Item[N],S).AbsoluteIndex;         //***
       with Lst.Items.AddChild(Lst.Items.Item[M],Base.GetData('TITRE')) do //***
        StateIndex := Base.GetCurrentRow;                                  //***
       L.Delete(0);                                                        //***
      end;                                                                 //***
    end;                                                                   //***
   base.Gonext;                                                            //***
  end;                                                                     //***
 L.Free;                                                                   //***
 I.Free;                                                                   //***
 F.Free;                                                                   //***
 Enabled := true;                                                          //***
end;                                                                       //***
                                                                           //***
// Tri Réalisateur                                                           ***
// même principe que le tri des acteurs                                      ***
Procedure TForm1.Tri_Realis;                                               //***
Var C : Char;                                                              //***
    M,N : integer;                                                         //***
    S : String;                                                            //***
begin                                                                      //***
 MakeFormBar;                                                              //***
 Base.GoFirst;                                                             //***
 lst.Items.Clear;                                                          //***
 while not Base.EndOfFile do                                               //***
  begin                                                                    //***
   S := Base.GetData('REALISATEUR');                                       //***
   if Length(S) = 0 then                                                   //***
    begin                                                                  //***
     I.Canvas.RoundRect(2,2,((I.Width-4) div Base.RowCount) * (Base.GetCurrentRow + 1),I.ClientHeight - 4,10,10);
     N := GetNodeWithTextasLevel(' Sans Réalisateur',0);                   //***
     if N = -1 then                                                        //***
     N := Lst.Items.AddFirst(nil,' Sans Réalisateur').AbsoluteIndex;       //***
     with Lst.Items.AddChild(Lst.Items.Item[N],Base.GetData('TITRE')) do   //***
      StateIndex := Base.GetCurrentRow;                                    //***
    end else                                                               //***
    begin                                                                  //***
       C := upcase(S[1]);                                                  //***
       S[1] := C;                                                          //***
       if not(C in ['A'..'Z']) then C := '#';                              //***
       N := GetNodeWithTextasLevel(C,0);                                   //***
       if N = -1 then                                                      //***
       N := Lst.Items.AddFirst(nil,C).AbsoluteIndex;                       //***
       M := GetNodeWithTextasLevel(S,1);                                   //***
       if M = -1 then                                                      //***
       M := Lst.Items.AddChild(Lst.Items.Item[N],S).AbsoluteIndex;         //***
       with Lst.Items.AddChild(Lst.Items.Item[M],Base.GetData('TITRE')) do //***
        StateIndex := Base.GetCurrentRow;                                  //***
    end;                                                                   //***
   base.Gonext;                                                            //***
  end;                                                                     //***
 I.Free;                                                                   //***
 F.Free;                                                                   //***
 Enabled := true;                                                          //***
end;                                                                       //***
                                                                           //***
// Tri Genre                                                                 ***
//   Chacun des titres est enregisté dans le noeud du genre correspondant    ***
Procedure TForm1.Tri_Genre;                                                //***
Var N : integer;                                                           //***
    S : String;                                                            //***
begin                                                                      //***
 MakeFormBar;                                                              //***
 Base.GoFirst;                                                             //***
 lst.Items.Clear;                                                          //***
 while not Base.EndOfFile do                                               //***
  begin                                                                    //***
   I.Canvas.RoundRect(2,2,((I.Width-4) div Base.RowCount) * (Base.GetCurrentRow + 1),I.ClientHeight - 4,10,10);
   S := Base.GetData('GENRE');                                             //***
   if Length(S) = 0 then S := ' Sans Genre';                               //***
   N := GetNodeWithTextasLevel(S,0);                                       //***
   if N = -1 then                                                          //***
   N := Lst.Items.AddFirst(Nil,S).AbsoluteIndex;                           //***
   with Lst.Items.AddChild(Lst.Items.Item[N],Base.GetData('TITRE')) do     //***
    StateIndex := Base.GetCurrentRow;                                      //***
   base.Gonext;                                                            //***
  end;                                                                     //***
 I.Free;                                                                   //***
 F.Free;                                                                   //***
 Enabled := true;                                                          //***
end;                                                                       //***
                                                                           //***
// Tri Support                                                               ***
//    chacun des titres est enregisté dans le noeud du support correspondant ***
Procedure TForm1.Tri_Support;
Var N : integer;                                                           //***
    S : String;                                                            //***
begin                                                                      //***
 MakeFormBar;                                                              //***
 Base.GoFirst;                                                             //***
 lst.Items.Clear;                                                          //***
 while not Base.EndOfFile do                                               //***
  begin                                                                    //***
   I.Canvas.RoundRect(2,2,((I.Width-4) div Base.RowCount) * (Base.GetCurrentRow + 1),I.ClientHeight - 4,10,10);
   S := Base.GetData('SUPPORT');                                           //***
   if Length(S) = 0 then S := ' Sans Support';                             //***
   N := GetNodeWithTextasLevel(S,0);                                       //***
   if N = -1 then                                                          //***
   N := Lst.Items.AddFirst(Nil,S).AbsoluteIndex;                           //***
   with Lst.Items.AddChild(Lst.Items.Item[N],Base.GetData('TITRE')) do     //***
    StateIndex := Base.GetCurrentRow;                                      //***
   base.Gonext;                                                            //***
  end;                                                                     //***
 I.Free;                                                                   //***
 F.Free;                                                                   //***
 Enabled := true;                                                          //***
end;                                                                       //***
                                                                           //***
// Tri par pret                                                              ***
//   affiche la liste des films prétés                                       ***
Procedure TForm1.Tri_Pret;                                                 //***
Var N : integer;                                                           //***
    S : String;                                                            //***
begin                                                                      //***
 Base.GoFirst;                                                             //***
 lst.Items.Clear;                                                          //***
 while not Base.EndOfFile do                                               //***
  begin                                                                    //***
   S := Base.GetData('PRET');                                              //***
   if Length(S) > 2 then                                                   //***
    begin                                                                  //***
     N := GetNodeWithTextasLevel(S,1);                                     //***
     if N = -1 then                                                        //***
     N := Lst.Items.AddFirst(Nil,S).AbsoluteIndex;                         //***
     with Lst.Items.AddChild(Lst.Items.Item[N],Base.GetData('TITRE')) do   //***
      StateIndex := Base.GetCurrentRow;                                    //***
    end;                                                                   //***
   base.Gonext;                                                            //***
  end;                                                                     //***
end;                                                                       //***
//******************************************************************************


{###############################################################################
#                                                                              #
#  Enregistre la fiche en court - si elle n'existe pas dans la base de données #
#     elle est alors créé                                                      #
#                                                                              #
###############################################################################}
procedure TForm1.EnregistreClick(Sender: TObject);
Var N : integer;
begin
 Lst.Color := $FFDDEE;
 lst.Font.Color := $0;
 Enregistre.Visible := False;
 Annul.Visible := False;
 Fiche1.Enabled := False;
 Fiche2.Enabled := False;
 E_Acteur.ReadOnly := True;
 E_Acteur.PopupMenu := Nil;

 if select = -1 then // Nouvelle fiche
  begin
   base.AddRow;     // ajout d'une fiche dans la base de données
   Select := Base.GetCurrentRow;
  end;
// ajout des informations dans les différentes listes
 if Length(E_genre.Text) > 2 then
 if E_Genre.Items.IndexOf(E_Genre.Text) = -1 then E_Genre.Items.Add(E_Genre.Text);

 if Length(E_Supp.Text) > 2 then
 if E_Supp.Items.IndexOf(E_Supp.Text) = -1 then E_Supp.Items.Add(E_Supp.Text);

 if Length(E_Realis.Text) > 2 then
 if Lst_Realis.IndexOf(E_Realis.Text) = -1 then Lst_Realis.Add(E_Realis.Text);

 N := 0;
 while N < E_Acteur.Lines.Count do
 if length(E_Acteur.Lines.Strings[N]) > 1 then inc(N)
    else E_Acteur.Lines.Delete(N);

 N := 0;
 While N < E_Acteur.Lines.Count do
  begin
   if Lst_Acteurs.IndexOf(E_Acteur.Lines.Strings[N]) = -1 then
     Lst_Acteurs.Add(E_Acteur.Lines.Strings[N]);
   inc(N);
  end;
// enregistrements des données
 base.SetData('TITRE',E_Titre.Text);
 base.SetData('GENRE',E_genre.Text);
 base.SetData('SUPPORT',E_Supp.Text);
 base.SetData('REALISATEUR',E_Realis.Text);
 base.SetData('ACTEURS',E_Acteur.Lines.Text);
 base.SetData('PRET',E_Pret.Text);
 if e_Date.Visible then base.SetData('DATEP',E_Date.Text)
                   else base.SetData('DATEP','');

 change := True; // pour savoir si il y a eu une modification de la base de donné
 Tab.Enabled := True;
 Base.SortByData('TITRE',True);
 case Tab.TabIndex of
  0 : Tri_Titre;
  1 : Tri_Acteurs;
  2 : Tri_Realis;
  3 : Tri_Genre;
  4 : Tri_Support;
  5 : tri_Pret;
 end;
 lst.Items.AlphaSort;
end;

// annulation des modifications en cours
procedure TForm1.annulClick(Sender: TObject);
begin
 Lst.Color := $FFDDEE;
 lst.Font.Color := $0;
 Tab.Enabled := True;
 Enregistre.Visible := False;
 Annul.Visible := False;
// Fiche.Enabled := False;
 Fiche1.Enabled := False;
 Fiche2.Enabled := False;
 E_Acteur.ReadOnly := True;
 E_Acteur.PopupMenu := Nil;
 affiche;
end;

// Exécution du tri en fonction de l'onglet sélectionné
procedure TForm1.TabChange(Sender: TObject);
begin
 case Tab.TabIndex of
  0 : Tri_Titre;
  1 : Tri_Acteurs;
  2 : Tri_Realis;
  3 : Tri_Genre;
  4 : Tri_Support;
  5 : tri_Pret;
 end;
 lst.Items.AlphaSort;
end;

// lance une sauvegarde de la base de données
procedure TForm1.SauverClick(Sender: TObject);
begin
 SaveBase(Fichier);
end;

// rend l'enregistrement de la date de pret accessible si un texte (3 caractètes mini) est saisi
procedure TForm1.E_PretChange(Sender: TObject);
begin
 E_Date.Visible := Length(E_Pret.Text) > 2;
 Enregistre.Enabled := Length(E_Titre.Text) > 0;
end;

// affichage du calendrier lors du click sur la date
procedure TForm1.E_DateClick(Sender: TObject);
begin
 Form3.Top := E_Date.ClientOrigin.Y - Form3.Height;
 Form3.Left := E_Date.ClientOrigin.X + E_Date.Width - Form3.Width;
 Form3.MonthCalendar1.Date := Now;
 Form3.ShowModal;
 E_Date.Text := DateToStr(Form3.MonthCalendar1.Date); // inscription de la date
end;

// permet d'entrer en mode de modification de fiche
procedure TForm1.lstDblClick(Sender: TObject);
begin
 if not Lst.Selected.HasChildren then // le noeud n'a pas d'enfant, c'est donc un film
  begin
   Select := Lst.Selected.StateIndex; // donnne la Ref. du film sélectionné
   Enregistre.Enabled := False;
   Fiche.Enabled := True;             // débloquage des différents champs
   Fiche1.Enabled := True;
   Fiche2.Enabled := True;
   E_Acteur.ReadOnly := False;
   Enregistre.Visible := True;
   Annul.Visible := True;
   Tab.Enabled := False;              // Bloquage de la liste de films
   Lst.Color := $FF5555;              // changement de couleur le la liste
   lst.Font.Color := $AAAAAA;
   Make_Menus;                        // création des menu-acteurs et réalisateurs
   E_Titre.ReadOnly := True;          // en mode modification, la modification du titre n'est pas possible (choix perso)
   E_Supp.SetFocus;                   // focus sur le support
  end;
end;

// changement de sélection dans la liste de films
procedure TForm1.lstChange(Sender: TObject; Node: TTreeNode);
begin
 if Node.HasChildren then
  begin                                         // c'est un noeud parent
   if Node.Expanded then Node.ImageIndex := 1   // affectation image noeud développé
                    else Node.ImageIndex := 0;  // affectation image noeud fermé
  end else
  begin                                         // c'est un film
   Node.ImageIndex := 2;
   base.Go(Node.StateIndex);                    // on positionne la base de donnée sur la fiche
   affiche;                                     // on affiche les données
  end;
 Fiche1.Enabled := False;                       // on maintien la fiche bloquées
 Fiche2.Enabled := False;
 E_Acteur.ReadOnly := True;
 E_acteur.PopupMenu := nil;
end;

// offre la possibilité de rentrer en mode de modification de données
// à l'aide du clavier
procedure TForm1.lstKeyPress(Sender: TObject; var Key: Char);
begin
 if (Key = #13) and (Lst.Selected <> nil) then
  if not Lst.Selected.HasChildren then lstdblclick(nil);
end;

// demande de fermeture de l'application
procedure TForm1.Quitter1Click(Sender: TObject);
begin
 Close;
end;

// lancement de la sauvegarde de la base de données
procedure TForm1.Save_BClick(Sender: TObject);
begin
 SaveBase(Fichier);
end;

// enregistrer la base de données sous
procedure TForm1.SaveSous_BClick(Sender: TObject);
begin
 SaveBase('');
end;

// permet d'afficher le menu principal en bloquant certaines fonctions selon l'état de l'application
procedure TForm1.menu_LstPopup(Sender: TObject);
Var C : TInifile;
    Lstf : TStringList;
    n : integer;
begin
 C := TInifile.Create(Rep_app + 'videos.cfg');   // recherche dans unfichier de configuration la liste
 Lstf := TStringList.Create;                     // des fichiers précédemment ouvert pour les ajouter
  try                                            // dans le menu rubrique : Réouvrir fichier
   C.ReadSectionValues('LIST_FICHIER',Lstf);
   n := 0;
   while N < Lstf.Count do                       // extraction de la liste de fichiers
    begin
     lstf.Strings[n] := copy(lstf.Strings[n],4,length(lstf.Strings[n]));
     inc(n);
    end;

    while RF.Count > 0 do RF.Delete(0);          // on efface les informations déjà existantes dans le menu
   n := 0;
   while N < Lstf.Count do                       // ajout de la liste des fichiers dans le menu
    begin
     RF.Add(TMenuitem.Create(nil));
     RF.Items[N].Caption := lstf.Strings[n];
     RF.Items[n].OnClick := reouvrir;
     inc(n);
    end;
   finally C.Free; lstf.Free; end;

 if lst.Selected = nil then  // activation-désactivation de certaines parties du menu en fonction
    Mod_F.Enabled := False   // de la sélection faite dans la liste
   else
    if Lst.Selected.HasChildren then
       Mod_F.Enabled := False
      else Mod_F.Enabled := True;

 Sup_F.Enabled := Mod_F.Enabled;
end;

// ouverture d'un fichier
procedure TForm1.Ouv_BClick(Sender: TObject);
begin
 if Openf.Execute then
  OuvrirBase(OpenF.FileName);
end;

procedure TForm1.Sup_FClick(Sender: TObject);
begin
 if messageDlg('Voullez vous réellement supprimer le film suivant :' + #13 +
               lst.Selected.Text,mtConfirmation,[mbYes,mbNo],-1) = mrYes then
  begin
   Base.RemoveRowByIndex(Lst.Selected.StateIndex);
   change := true;
   case Tab.TabIndex of
    0 : Tri_Titre;
    1 : Tri_Acteurs;
    2 : Tri_Realis;
    3 : Tri_Genre;
    4 : Tri_Support;
    5 : tri_Pret;
   end;
   lst.Items.AlphaSort;
  end;
end;

// rend l'enregistrement du film possible si un titre est saisi
procedure TForm1.E_TextChange(Sender: TObject);
begin
 Enregistre.Enabled := Length(E_Titre.Text) > 0;
end;

// Fermeture définitive de l'application
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
Var C : TInifile;
begin
 Lst_Acteurs.free;
 Lst_Realis.Free;
 // enregistrement du fichier utilisé en vu de le réouvrir automatiquement au prochain lancement
 C := TInifile.Create(Rep_app + 'videos.cfg');
  try
   if length(fichier) > 2 then
     C.WriteString('FICHIER','DERNIER',ExpandFileName(fichier));
  finally C.Free; end;
end;

// ouverture d'un fichier sélectionné dans la liste "Réouvrir fichier"
Procedure TForm1.reouvrir(sender : Tobject);
begin
 if Fileexists((sender as tmenuitem).Caption) then
  OuvrirBase((sender as tmenuitem).Caption);
end;

// Génération dynamique des popupmenu réalisateur et acteur
Procedure Tform1.Make_Menus;
Var N : integer;
    M : TMenuItem;
begin
// destruction des menus existants
 while M_Acteurs.Items.Count > 0 do
  M_Acteurs.Items.Delete(0);
 while M_Realis.Items.Count > 0 do
  M_Realis.Items.Delete(0);
 Lst_Acteurs.Sort;
 Lst_Realis.Sort;

//Création du menu acteurs
 M_Acteurs.Items.Add(Tmenuitem.Create(nil));   // on commence par créer les lignes
 with M_Acteurs.Items.Items[0] do              // couper
  begin                                        // copier
   Caption := 'Couper';                        // Coller
   OnClick := Act_Couper;
  end;
 M_Acteurs.Items.Add(Tmenuitem.Create(nil));
 with M_Acteurs.Items.Items[1] do
  begin
   Caption := 'Copier';
   OnClick := Act_Copier;
  end;
 M_Acteurs.Items.Add(Tmenuitem.Create(nil));
 with M_Acteurs.Items.Items[2] do
  begin
   Caption := 'Coller';
   OnClick := Act_Coller;
  end;
 M_Acteurs.Items.Add(Tmenuitem.Create(nil));
 M_Acteurs.Items.Items[3].Caption := '-';

 N := 0;
 While N < Lst_Acteurs.Count Do   //listage de tous les acteurs - triés par ordre alphabétique
  begin                           // la première lettre de l'acteur servira à créer un menu parent
   if M_Acteurs.Items.Find(upcase(lst_Acteurs.Strings[N][1])) = Nil then // le menu parent existe t'il ?
    begin   // non donc on le créé
     M_Acteurs.Items.Add(TmenuItem.Create(nil));
     M_Acteurs.Items.Items[M_Acteurs.Items.Count-1].Caption := upcase(lst_Acteurs.Strings[N][1]);
    end;
    M := TMenuItem.Create(nil); // création de l'item de l'acteur
    with M do
     begin
      Caption := lst_Acteurs.Strings[N];
      OnClick := lst_Act_Click; // action exécuté quand on click dessus
     end;
    M_Acteurs.Items.Find(upcase(lst_Acteurs.Strings[N][1])).Add(M); // ajout de l'item dans celui
                                                                    // contenant la première lettre de l'acteur
   inc(N);
  end;

// Création du menu réalisateurs => principe identique au menu des acteurs
 M_Realis.Items.Add(Tmenuitem.Create(nil));
 with M_Realis.Items.Items[0] do
  begin
   Caption := 'Couper';
   OnClick := Rea_Couper;
  end;
 M_Realis.Items.Add(Tmenuitem.Create(nil));
 with M_Realis.Items.Items[1] do
  begin
   Caption := 'Copier';
   OnClick := Rea_Copier;
  end;
 M_Realis.Items.Add(Tmenuitem.Create(nil));
 with M_Realis.Items.Items[2] do
  begin
   Caption := 'Coller';
   OnClick := Rea_Coller;
  end;
 M_Realis.Items.Add(Tmenuitem.Create(nil));
 M_Realis.Items.Items[3].Caption := '-';

 N := 0;
 While N < Lst_Realis.Count Do
  begin
   if M_Realis.Items.Find(upcase(Lst_Realis.Strings[N][1])) = Nil then
    begin
     M_Realis.Items.Add(TmenuItem.Create(nil));
     M_Realis.Items.Items[M_Realis.Items.Count-1].Caption := upcase(Lst_Realis.Strings[N][1]);
    end;
    M := TMenuItem.Create(nil);
    with M do
     begin
      Caption := Lst_Realis.Strings[N];
      OnClick := lst_Rea_Click;
     end;
     M_Realis.Items.Find(upcase(Lst_Realis.Strings[N][1])).Add(M);
   inc(N);
  end;

 M_Acteurs.OnPopup := Act_Menu;
 M_Realis.OnPopup := Rea_Menu;
 E_Acteur.PopupMenu := M_Acteurs;
 E_Realis.PopupMenu := M_Realis;

end;

// création d'un nouvelle fiche vierge
procedure TForm1.Nouv_FClick(Sender: TObject);
begin
 Select := -1;
 make_Menus;
 Tab.Enabled := False;
 Fiche1.Enabled := True;
 Fiche2.Enabled := True;
 E_Acteur.ReadOnly := False;
 E_Titre.ReadOnly := False;
 E_Titre.Text := '';
 E_Supp.Text := '';
 E_genre.Text := '';
 E_Acteur.Lines.Clear;
 E_Realis.Text := '';
 E_Date.Text := '';
 E_Pret.Text := '';
 Enregistre.Visible := True;
 Annul.Visible := True;
 Enregistre.Enabled := False;
 Lst.Color := $FF5555;
 lst.Font.Color := $AAAAAA;
 E_titre.SetFocus;
end;


// Impression du listing
procedure TForm1.ImprimerClick(Sender: TObject);
Var R : Array [1..6] of Trect;
    P,N,O,F : integer;
    L : TStringList;
begin
if Base.RowCount > 0 then
if PrintD.Execute then
 begin
  F := GetDeviceCaps(Printer.Handle, LOGPIXELSY) Div 8;
  L := TStringList.Create;
  printer.Title := 'Liste des Vidéos';
  printer.BeginDoc;
  P := Printer.PageWidth div 400;
  printer.Canvas.Brush.Color := $DDDDDD;
  printer.Canvas.Brush.Style := bsClear;
  printer.Canvas.Pen.Color := clblack;
  printer.Canvas.Pen.Style := psSolid;
  printer.Canvas.Pen.Width := 2;
  printer.Canvas.Font.Height := F;
  printer.Canvas.Font.Style := [fsBold];
  printer.Canvas.Font.Name := 'Arial';
  R[1].Left := F * 2;      R[1].Right := R[1].Left + P * 100; R[1].Top := P div 2;
  R[2].Left := R[1].Right; R[2].Right := R[2].Left + P * 40; R[2].Top := P div 2;
  R[3].Left := R[2].Right; R[3].Right := R[3].Left + P * 40; R[3].Top := P div 2;
  R[4].Left := R[3].Right; R[4].Right := R[4].Left + P * 80; R[4].Top := P div 2;
  R[5].Left := R[4].Right; R[5].Right := R[5].Left + P * 80; R[5].Top := P div 2;
  R[6].Left := R[5].Right; R[6].Right := Printer.PageWidth - F * 2; R[6].Top := P div 2;
  R[1].Bottom := R[1].Top + 2 * F;
  R[2].Bottom := R[2].Top + 2 * F;
  R[3].Bottom := R[3].Top + 2 * F;
  R[4].Bottom := R[4].Top + 2 * F;
  R[5].Bottom := R[5].Top + 2 * F;
  R[6].Bottom := R[6].Top + 2 * F;
  Printer.Canvas.Rectangle(R[1]); Printer.Canvas.TextRect(R[1],R[1].Left + (R[1].Right - R[1].Left - Printer.Canvas.TextWidth('TITRE')) div 2,R[1].Top + F div 2,'TITRE');
  Printer.Canvas.Rectangle(R[2]); Printer.Canvas.TextRect(R[2],R[2].Left + (R[2].Right - R[2].Left - Printer.Canvas.TextWidth('GENRE')) div 2,R[2].Top + F div 2,'GENRE');
  Printer.Canvas.Rectangle(R[3]); Printer.Canvas.TextRect(R[3],R[3].Left + (R[3].Right - R[3].Left - Printer.Canvas.TextWidth('SUPPORT')) div 2,R[3].Top + F div 2,'SUPPORT');
  Printer.Canvas.Rectangle(R[4]); Printer.Canvas.TextRect(R[4],R[4].Left + (R[4].Right - R[4].Left - Printer.Canvas.TextWidth('ACTEURS')) div 2,R[4].Top + F div 2,'ACTEURS');
  Printer.Canvas.Rectangle(R[5]); Printer.Canvas.TextRect(R[5],R[5].Left + (R[5].Right - R[5].Left - Printer.Canvas.TextWidth('REALISATEUR')) div 2,R[5].Top + F div 2,'REALISATEUR');
  Printer.Canvas.Rectangle(R[6]); Printer.Canvas.TextRect(R[6],R[6].Left + (R[6].Right - R[6].Left - Printer.Canvas.TextWidth('PRET')) div 2,R[6].Top + F div 2,'PRET');
  N := 0;
  Base.GoFirst;
  while N < base.RowCount do
   begin
    L.Clear;
    L.Text := Base.GetDataByIndex(4);
    R[1].Top := R[1].Bottom;
    if length(Base.GetDataByIndex(6)) > 0 then R[1].Bottom := R[1].Top + 3 * F
                                          else R[1].Bottom := R[1].Top + 2 * F;

    if (R[1].Top + ((L.Count + 1) * F)) > R[1].Bottom then
      R[1].Bottom := R[1].Top + ((L.Count + 1) * F);

    if R[1].Bottom > (Printer.PageHeight - P div 2) then
     begin
      Printer.NewPage;
      R[1].Left := F * 2;      R[1].Right := R[1].Left + P * 100; R[1].Top := P div 2;
      R[2].Left := R[1].Right; R[2].Right := R[2].Left + P * 40; R[2].Top := P div 2;
      R[3].Left := R[2].Right; R[3].Right := R[3].Left + P * 40; R[3].Top := P div 2;
      R[4].Left := R[3].Right; R[4].Right := R[4].Left + P * 80; R[4].Top := P div 2;
      R[5].Left := R[4].Right; R[5].Right := R[5].Left + P * 80; R[5].Top := P div 2;
      R[6].Left := R[5].Right; R[6].Right := Printer.PageWidth - F * 2; R[6].Top := P div 2;
      R[1].Bottom := R[1].Top + 2 * F;
      R[2].Bottom := R[2].Top + 2 * F;
      R[3].Bottom := R[3].Top + 2 * F;
      R[4].Bottom := R[4].Top + 2 * F;
      R[5].Bottom := R[5].Top + 2 * F;
      R[6].Bottom := R[6].Top + 2 * F;
      Printer.Canvas.Rectangle(R[1]); Printer.Canvas.TextRect(R[1],R[1].Left + (R[1].Right - R[1].Left - Printer.Canvas.TextWidth('TITRE')) div 2,R[1].Top + F div 2,'TITRE');
      Printer.Canvas.Rectangle(R[2]); Printer.Canvas.TextRect(R[2],R[2].Left + (R[2].Right - R[2].Left - Printer.Canvas.TextWidth('GENRE')) div 2,R[2].Top + F div 2,'GENRE');
      Printer.Canvas.Rectangle(R[3]); Printer.Canvas.TextRect(R[3],R[3].Left + (R[3].Right - R[3].Left - Printer.Canvas.TextWidth('SUPPORT')) div 2,R[3].Top + F div 2,'SUPPORT');
      Printer.Canvas.Rectangle(R[4]); Printer.Canvas.TextRect(R[4],R[4].Left + (R[4].Right - R[4].Left - Printer.Canvas.TextWidth('ACTEURS')) div 2,R[4].Top + F div 2,'ACTEURS');
      Printer.Canvas.Rectangle(R[5]); Printer.Canvas.TextRect(R[5],R[5].Left + (R[5].Right - R[5].Left - Printer.Canvas.TextWidth('REALISATEUR')) div 2,R[5].Top + F div 2,'REALISATEUR');
      Printer.Canvas.Rectangle(R[6]); Printer.Canvas.TextRect(R[6],R[6].Left + (R[6].Right - R[6].Left - Printer.Canvas.TextWidth('PRET')) div 2,R[6].Top + F div 2,'PRET');
     end;
    R[2].Top := R[1].Top; R[2].Bottom := R[1].Bottom;
    R[3].Top := R[1].Top; R[3].Bottom := R[1].Bottom;
    R[4].Top := R[1].Top; R[4].Bottom := R[1].Bottom;
    R[5].Top := R[1].Top; R[5].Bottom := R[1].Bottom;
    R[6].Top := R[1].Top; R[6].Bottom := R[1].Bottom;

    if (N mod 2) = 0 then
                      begin
                       Printer.Canvas.Brush.Style := bsSolid;
                       Printer.Canvas.Brush.Color := $EEEEEE;
                      end
                     else Printer.Canvas.Brush.Style := bsClear;
    Printer.Canvas.Rectangle(R[1]);
    Printer.Canvas.Rectangle(R[2]);
    Printer.Canvas.Rectangle(R[3]);
    Printer.Canvas.Rectangle(R[4]);
    Printer.Canvas.Rectangle(R[5]);
    Printer.Canvas.Rectangle(R[6]);

    Printer.Canvas.Brush.Style := bsClear;
    Printer.Canvas.TextRect(R[1],R[1].Left + P,R[1].Top + F div 2,Base.GetDataByIndex(1));
    Printer.Canvas.TextRect(R[2],R[2].Left + P,R[2].Top + F div 2,Base.GetDataByIndex(3));
    Printer.Canvas.TextRect(R[3],R[3].Left + P,R[3].Top + F div 2,Base.GetDataByIndex(2));
    O := 0;
    While O < L.Count do
     begin
      Printer.Canvas.TextRect(R[4],R[4].Left + P,R[4].Top + (F * O) + (F div 2),L.Strings[O]);
      inc(O);
     end;
    Printer.Canvas.TextRect(R[5],R[5].Left + P,R[5].Top + P,Base.GetDataByIndex(5));
    if length(Base.GetDataByIndex(6)) > 0 then
     begin
      Printer.Canvas.TextRect(R[6],R[6].Left + P,R[6].Top + F div 2,Base.GetDataByIndex(6));
      if length(Base.GetDataByIndex(7)) > 0 then
       Printer.Canvas.TextRect(R[6],R[6].Left + P,R[6].Top + F div 2 + F,Base.GetDataByIndex(7));
     end;
    Base.GoNext;
    inc(N);
   end;
  Printer.EndDoc;
 end;
end;

// demande de création d'une nouvelle base de données
procedure TForm1.Nouv_BClick(Sender: TObject);
begin
 nouvelleBase;
end;


procedure TForm1.Listedestitres1Click(Sender: TObject);
Var Nb_Col,sel_Col : byte;
    F, N, Y : integer;
    L : TStringList;

begin
if Base.RowCount > 0 then
if PrintD.Execute then
 begin
  F := GetDeviceCaps(Printer.Handle, LOGPIXELSY) Div 8;
  if Printer.Orientation = poLandscape then nb_col := 3 else nb_col := 2;
  L := TStringList.Create;
  L.Sorted := True;
  Base.GoFirst;
  while L.Count < base.RowCount do
   begin
    L.Add(Base.GetData('TITRE'));
    Base.GoNext;
   end;
  with Printer.Canvas do
   begin
    Font.Height := F;
    Font.Style := [fsBold];
    Font.Name := 'Arial';
    Brush.Style :=bsSolid;
   end;
  L.Sort;
  printer.Title := 'Liste des Vidéos';
  printer.BeginDoc;
  Y := F * 2;
  Sel_col := 1;
  N := 0;
  While N < L.Count do
  With Printer.Canvas do
   begin
    if N = 0 then
     begin
      Font.Height := F;
      Font.Style := [fsbold,fsunderline];
      TextOut(F * 2,Y,upcase(L.Strings[0][1]) + ' :');
      inc(Y,F);
      Font.Style := [fsbold];
     end else
     if upcase(L.Strings[N-1][1]) <> Upcase(L.Strings[N][1]) then
      begin
       Font.Height := F;
       Font.Style := [fsbold,fsunderline];
       TextOut((Printer.PageWidth div 2) * (Sel_Col - 1) + F * 2,Y,upcase(L.Strings[N][1]) + ' :');
       inc(Y,F);
       Font.Style := [fsbold];
      end;
    TextRect(Rect((Sel_Col - 1) * (Printer.PageWidth div Nb_Col) + F * 3,Y,Sel_Col * (Printer.PageWidth div Nb_Col) - (f * 2),Y + F),
                  (Sel_Col - 1) * (Printer.PageWidth div Nb_Col) + F * 3,Y,L.Strings[N]);
    inc(Y,F);
    inc(N);
    if N < L.Count then
     begin
     if upcase(L.Strings[N-1][1]) = Upcase(L.Strings[N][1]) then
      begin
       if Y > (Printer.PageHeight - (3 * F)) then
        begin
         Y := F * 2;
         inc(Sel_Col);
        end;
      end else
       if Y > (Printer.PageHeight - (5 * F)) then
        begin
         Y := F * 2;
         inc(Sel_Col);
        end;
     if Sel_Col > Nb_Col then
      begin
       Printer.NewPage;
       Y := F * 2;
       Sel_Col := 1;
      end;
     end;
   end;
  Printer.EndDoc;
 end;
end;

// modification de l'image du noeud lors de sont ouverture ou de sa fermeture //
//                                                                            //
//                                                                            //
procedure TForm1.lstCollapsed(Sender: TObject; Node: TTreeNode);              //
begin                                                                         //
 if Node.Expanded then Node.ImageIndex := 1                                   //
                  else Node.ImageIndex := 0;                                  //
 Node.SelectedIndex := Node.ImageIndex;                                       //
end;                                                                          //
                                                                              //
procedure TForm1.lstExpanded(Sender: TObject; Node: TTreeNode);               //
begin                                                                         //
 if Node.Expanded then Node.ImageIndex := 1                                   //
                  else Node.ImageIndex := 0;                                  //
 Node.SelectedIndex := Node.ImageIndex;                                       //
end;                                                                          //
////////////////////////////////////////////////////////////////////////////////

// ajout d'un fichier dans la liste des dernier fichiers ouverts
Procedure TForm1.Add_denier_Fichier;
Var C : TInifile;
    Lstf : TStringList;
    n : integer;
begin
 C := TInifile.Create(Rep_app + 'videos.cfg');
 Lstf := TStringList.Create;
  try
   if length(fichier) > 2 then
    begin
     C.ReadSectionValues('LIST_FICHIER',Lstf);
     n := 0;
     while N < Lstf.Count do
      begin
       lstf.Strings[n] := copy(lstf.Strings[n],4,length(lstf.Strings[n]));
       inc(n);
      end;
     if Lstf.IndexOf(ExpandFileName(fichier)) < 0 then
      begin
       if lstf.Count = 10 then lstf.Delete(0);
       lstf.Add(ExpandFileName(fichier));
       n := 0;
       while N < lstf.Count do
        begin
         C.WriteString('LIST_FICHIER','F' + inttostr(N),lstf.Strings[n]);
         inc(n);
        end;
      end;
    end;
  finally C.Free; Lstf.Free; End;
end;


{###############################################################################
###                                                                          ###
###    Gestion du Drag and Drop de text depuis l'extérieur de l'application  ###
###    les choix possibles                                                   ###
###    - DROPEFFECT_NONE    => DROP NON ACTIF                                ###
###    - DROPEFFECT_COPY    => COPIE DE LA DONNEE                            ###
###    - DROPEFFECT_MOVE    => COUPE LES DONNEES DE LA SOURCE ET COPIE DANS  ###
###                            DANS L'APPLICATION                            ###
###    - DROPEFFECT_LINK    => ????                                          ###
###    - DROPEFFECT_MOVE    => ???                                           ###
###                                                                          ###
###     toutes ses infos sont dans le fichier "ActiveX.pas"                  ###
###                                                                          ###
###############################################################################}
procedure TForm1.FormDestroy(Sender: TObject);
begin
  RevokeDragDrop(Handle);
  OleUninitialize;
end;

function TForm1.DragEnter(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult;
begin
  dwEffect := DROPEFFECT_NONE; // choix pour drop actif dès l'entrée dans la Form
  Result  := S_OK;
end;

function TForm1.DragOver(grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult;
Var n : int64;
Begin
  dwEffect := DROPEFFECT_None; // Drop non actif par défaut
  if Fiche1.Enabled then
   begin
    N := GetComponentIndex(Pt);
    if N > -1 then
     begin
      if (Components[N].Name = 'E_Supp')or
         (Components[N].Name = 'E_genre') or
         (Components[N].Name = 'E_Acteur') or
         (Components[N].Name = 'E_Realis') then
         dwEffect := DROPEFFECT_COPY;            // Détection du composant survolé, et choix d'une copie
     end;
   end;
  Result := S_OK;
end;

function TForm1.DragLeave: HResult;
begin
 Result := S_OK;
end;


function TForm1.Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult;
var
  aFmtEtc: TFORMATETC;
  aStgMed: TSTGMEDIUM;
  pData: PChar;

  I : integer;
begin
  if (dataObj = nil) then
    raise Exception.Create('IDataObject-Pointer is not valid!');
  // préparation du format de réception ( TEXTE )
  with aFmtEtc do
  begin
    cfFormat := CF_TEXT;
    ptd := nil;
    dwAspect := DVASPECT_CONTENT;
    lindex := -1;
    tymed := TYMED_HGLOBAL;
  end;
  // récupération des données
  OleCheck(dataObj.GetData(aFmtEtc, aStgMed));
  try
    pData := GlobalLock(aStgMed.hGlobal); // pdata contien le texte à importer

    // gestion en fonction des différents contols
    if components[GetComponentIndex(Pt)].Name = 'E_Supp' then E_Supp.Text := pData else
    if components[GetComponentIndex(Pt)].Name = 'E_genre' then E_genre.Text := pData else
    if components[GetComponentIndex(Pt)].Name = 'E_Realis' then E_Realis.Text := pData else
    if components[GetComponentIndex(Pt)].Name = 'E_Acteur' then
      begin
       // Calcul de la position du pointeur de la souris pour positionner le texte à une position précise dans le TMemo
       I := (pt.Y - (Top + (Height - ClientHeight) + E_Acteur.Top)) shl 16 +
           (pt.X - (Left + (Width - ClientWidth) div 2 + E_Acteur.Left));
       I := LoWord(E_Acteur.Perform(EM_CHARFROMPOS, 0, I));
       E_Acteur.SelStart := I;        // on positionne le curseur de selection sous le pointeur de la souris
       E_Acteur.SetSelTextBuf(pdata); // on insert le text là où est le curseur
      end;
  finally
   GlobalUnlock(aStgMed.hGlobal);
   ReleaseStgMedium(aStgMed);
  end;
  Result := S_OK;
end;

// on cherche en premier les composants enfant  -> comptage en décroissant
Function TForm1.GetComponentIndex(pt : TPoint) : Int64;
Var C : int64; K : boolean;
begin
 C := Pred(ComponentCount);
 K := True;
 Result := -1;
 while K  and (C >= 0) do
  begin
  if (Components[c] is TLabeledEdit) or
     (Components[c] is TMemo) or
     (Components[c] is TCombobox) then
   with (Components[C] as Tcontrol) do begin
     if (Pt.X >= ClientOrigin.X)and (Pt.X <= (ClientOrigin.X + Width)) and
     (Pt.Y >= ClientOrigin.Y) and (Pt.Y <= (ClientOrigin.Y + Height)) then
      begin
       result := C;
       K := False;
      end;
    end;
  dec(C);
 end;
end;    

end.
