import tkinter as tk
from tkinter import ttk
from SQLViewerApp import SQLViewerApp
from SQLViewerApp2 import SQLViewerApp2
from SQLViewerApp3 import SQLViewerApp3
import pyodbc


conn_str = (
    "Driver=ODBC Driver 17 for SQL Server;"
    "Server=localhost;"
    "Database=CasernePompier1;"
    "Encrypt=yes;"
    "TrustServerCertificate=yes;"
    "Trusted_Connection=yes;"
)
class MainWindow:
    def __init__(self, root):
        self.root = root
        self.root.title("Casernes des pompiers")
        #root.geometry ("1000x300")
        # Create a menu bar
        self.menu_bar = tk.Menu(root)
        self.root.config(menu=self.menu_bar)

        # Connecting to SQL Server database
        self.conn = pyodbc.connect(conn_str)
        self.cursor = self.conn.cursor()

        # Load and set background image
        self.bg_image = tk.PhotoImage(
            file="background_image_resized.gif")

        # Create a Canvas widget to place the background image
        self.canvas = tk.Canvas(self.root, width=self.bg_image.width(), height=self.bg_image.height())
        #self.canvas = tk.Canvas(self.root, width=4000, height=1000)
        self.canvas.pack()

        self.canvas.create_image(0, 0, anchor=tk.NW, image=self.bg_image)

        # Create a frame to contain the buttons
        self.button_frame = tk.Frame(self.canvas, bg="white", width=25,
                                     height=25)
        label_font = ("Helvetica", 20, "bold")
        buttonFrameLabel = ttk.Label(self.button_frame, text = "Bienvenue dans la base de donnée de la gestion des casernes", font = label_font)
        buttonFrameLabel.pack()

        button_font = ("Helvetica", 12)
        self.button_frame.place(relx=0.5, rely=0.5, anchor=tk.CENTER)
        self.button1 = tk.Button(self.button_frame, text="Recherche par id caserne", command=self.open_window1, width=25, height=5, font = button_font)
        self.button1.pack(side="left", padx=25,pady=20)

        self.button2 = tk.Button(self.button_frame, text="Recherche par id equipe", command=self.open_window2,width=25, height=5, font=button_font)
        self.button2.pack(side="left", padx=20,pady=20)

        self.button3 = tk.Button(self.button_frame, text="Recherche par autres critères", command=self.open_window3,width=25, height=5, font=button_font)
        self.button3.pack(side="left", padx=20,pady=20)


    def open_sql_viewer(self):
        # Create and open the SQL Viewer app window
        sql_viewer_root = tk.Toplevel(self.root)
        sql_viewer_app = SQLViewerApp(sql_viewer_root)


    def insert_record(self):
        NAS = self.NAS_entry.get()
        name = self.name_entry.get()
        prenom= self.prenom_entry.get()

        if NAS and name and prenom:
            self.cursor.execute("INSERT INTO pompier (NAS, Nom ,Prenom, id_equipe) VALUES (?, ?, ?,?)", (NAS, name, prenom,1))
            self.conn.commit()
            self.NAS_entry.delete(0, tk.END)
            self.name_entry.delete(0, tk.END)

    def open_window1(self):
        new_window = tk.Toplevel(self.root)

        sql_viewer = SQLViewerApp(new_window)

    def open_window2(self):
        new_window = tk.Toplevel(self.root)
        sql_viewer = SQLViewerApp2(new_window)

    def open_window3(self):
        new_window = tk.Toplevel(self.root)
        sql_viewer = SQLViewerApp3(new_window)

if __name__ == "__main__":
    root = tk.Tk()
    app = MainWindow(root)
    root.mainloop()
