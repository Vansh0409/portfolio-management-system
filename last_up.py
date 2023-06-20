from tkinter import *
from tkinter import ttk
import random
import time
import datetime
from tkinter import messagebox
import mysql.connector

guserID = ""


"""Description for Login Class:-
This class defines a login interface using the tkinter library in Python. 
It contains a constructor method that initializes the user ID and password variables, 
sets up the graphical user interface (GUI), and creates a button to trigger a login function. 
The login function validates the user's credentials by checking them against a MySQL database. 
If the credentials are correct, the user is granted access to the system, and the class variable 'guserID' is set to the user ID. 
Otherwise, an error message is displayed."""
class login:
    def __init__(self, root):
        self.userid = StringVar()
        self.password = StringVar()

        self.root = root
        self.root.title("Login")
        self.root.geometry("640x480+0+0")

        MainFrame = Frame(self.root, bd=0,padx=10, relief=RIDGE)
        MainFrame.place(x=0, y=0, width=640, height = 480)

        lblUsername = Label(MainFrame, text="UserID : ", font=("times new roman", 12, "bold"), padx=2, pady=6)
        lblUsername.grid(row=0, column=0, sticky=W)
        lblUsername = Entry(MainFrame,textvariable=self.userid ,font=("times new roman", 12, "bold"), width=35)
        lblUsername.grid(row=0, column=1)

        lblPwd = Label(MainFrame, text="Password : ", font=("times new roman", 12, "bold"), padx=2, pady=6)
        lblPwd.grid(row=1, column=0, sticky=W)
        lblPwd = Entry(MainFrame, textvariable=self.password ,font=("times new roman", 12, "bold"), width=35)
        lblPwd.grid(row=1, column=1)

        btnLogin=Button(MainFrame, text="Login",bg="green",fg="white",command=self.checker, font=("times new roman", 12, "bold"), width=23, padx=2, pady=6)
        btnLogin.grid(row=2, column=1)

    def checker(self):
        if self.userid.get()=="" or self.password.get()=="":
            messagebox.showerror("Error", "Enter both userID and Password")
        else:
            conn=mysql.connector.connect(host="localhost", username="root", password="dbms@123", database="portfolio")
            my_cursor=conn.cursor()
            my_cursor.execute("SELECT password FROM user WHERE userID = %s", (self.userid.get(),))
            result = my_cursor.fetchone()
            if result and result[0] == self.password.get():
                messagebox.showinfo("Success", "Login successful!")
                global guserID
                guserID = self.userid.get()
                self.root.destroy()
            else:
                messagebox.showerror("Error", "Invalid username or password.")
            conn.commit()
            conn.close()

"""Description for portfolioPH Class:-
This code is a Python class called portfolioPH that defines a GUI application for portfolio management system. 
The GUI contains a treeview widget to display holdings with their performance, and an entry form to input details of holdings. 
The class also defines several variables and functions to handle user inputs and interact with the treeview widget.
The treeview widget contains columns for holding ID, year, month, invest ID, name, and quantity of holdings. 
The code also includes scrollbars to allow the user to scroll through the widget if the content exceeds the widget size.
The entry form includes input fields for holding ID, year, month, invest ID, name, and quantity. 
The user can enter the details of a new holding in these fields and submit the details to add a new row to the treeview widget."""
class portfolioPH:
    def __init__(self, root):
        self.userid = StringVar()
        self.userid.set(guserID)
        self.holdingID = StringVar()
        self.year = StringVar()
        self.month = StringVar()
        self.investID = StringVar()
        self.riskLevel = StringVar()
        self.totalReturns = StringVar()
        self.annualizedReturns = StringVar()
        
        self.quantity = StringVar()

        self.root = root
        self.root.title("Portfolio Management System")
        self.root.geometry("1280x720+0+0")

        MainFrame = Frame(self.root, bd=0,padx=10, relief=RIDGE)
        MainFrame.place(x=0, y=0, width=1280, height = 720)

        lblHoldings = Label(MainFrame, text="Holdings with their Performance", font=("times new roman", 12, "bold"), padx=0, pady=6)
        lblHoldings.grid(row=0, column=0, sticky=W)

         # ==============================Details Frame==========================
        Detailsframe=Frame(MainFrame, bd=0,padx=0, relief=RIDGE)
        Detailsframe.place(x=0, y=40, width=1200, height = 400)
        # =========================table================================
        scroll_x=ttk.Scrollbar(Detailsframe, orient=HORIZONTAL)
        scroll_y=ttk.Scrollbar(Detailsframe, orient=VERTICAL)
        self.HoldingsP=ttk.Treeview(Detailsframe, column=("holdingsID", "year", "month","investID", "name", "quantity", "riskLevel", "totalReturns", "annualizedReturns"), xscrollcommand=scroll_x.set, yscrollcommand=scroll_y.set)
        # self.HoldingsP=ttk.Treeview(Detailsframe, column=("holdingsID", "year", "month", "investID", "name", "quantity"), xscrollcommand=scroll_x.set, yscrollcommand=scroll_y.set)
        scroll_x.pack(side=BOTTOM,fill=X)
        scroll_y.pack(side=RIGHT,fill=Y)

        scroll_x=ttk.Scrollbar(command=self.HoldingsP.xview)
        scroll_y=ttk.Scrollbar(command=self.HoldingsP.yview)

        self.HoldingsP.heading("holdingsID", text="HoldingID")
        self.HoldingsP.heading("year", text="Year")
        self.HoldingsP.heading("month", text="Month")
        self.HoldingsP.heading("investID", text="Invest ID")
        self.HoldingsP.heading("name", text="Name")
        self.HoldingsP.heading("quantity", text="Quantity")
        self.HoldingsP.heading("riskLevel", text="Risk Level")
        self.HoldingsP.heading("totalReturns", text="Total Returns")
        self.HoldingsP.heading("annualizedReturns", text="Annualized Returns")

        self.HoldingsP["show"]="headings"
        
        self.HoldingsP.column("holdingsID", width=100)
        self.HoldingsP.column("year", width=100)
        self.HoldingsP.column("month", width=100)
        self.HoldingsP.column("investID", width=100)
        self.HoldingsP.column("name", width=100)    
        self.HoldingsP.column("quantity", width=100)
        self.HoldingsP.column("riskLevel", width=100)
        self.HoldingsP.column("totalReturns", width=100)
        self.HoldingsP.column("annualizedReturns", width=100)
        
        self.HoldingsP.pack(fill=BOTH, expand=1)
        self.HoldingsP.bind("<ButtonRelease-1>",self.get_cursor)
        # Edits by Vansh
        
        # Edit ends
        
        # Button Frame
        ButtonFrame=Frame(MainFrame, bd=0,padx=0, relief=RIDGE)
        ButtonFrame.place(x=0, y=400, width=1200, height = 320)
        
        
        lblUsername = Label(ButtonFrame, text="Holding ID : ", font=("times new roman", 12, "bold"), padx=2, pady=6)
        lblUsername.grid(row=0, column=0, sticky=W)
        lblUsername = Entry(ButtonFrame ,font=("times new roman", 12, "bold"), textvariable=self.holdingID,width=35)
        lblUsername.grid(row=0, column=1, sticky=W)
        
        
        lblUsername = Label(ButtonFrame, text="Year : ", font=("times new roman", 12, "bold"), padx=2, pady=6)
        lblUsername.grid(row=1, column=0, sticky=W)
        lblUsername = Entry(ButtonFrame ,font=("times new roman", 12, "bold"),textvariable=self.year, width=35)
        lblUsername.grid(row=1, column=1, sticky=W)

        lblUsername = Label(ButtonFrame, text="Month : ", font=("times new roman", 12, "bold"), padx=2, pady=6)
        lblUsername.grid(row=2, column=0, sticky=W)
        lblUsername = Entry(ButtonFrame ,font=("times new roman", 12, "bold"),textvariable=self.month, width=35)
        lblUsername.grid(row=2, column=1, sticky=W)
        
        lblUsername = Label(ButtonFrame, text="investID : ", font=("times new roman", 12, "bold"), padx=2, pady=6)
        lblUsername.grid(row=3, column=0, sticky=W)
        lblUsername = Entry(ButtonFrame ,font=("times new roman", 12, "bold"),textvariable=self.investID, width=35)
        lblUsername.grid(row=3, column=1, sticky=W)

        lblUsername = Label(ButtonFrame, text="Quantity : ", font=("times new roman", 12, "bold"), padx=2, pady=6)
        lblUsername.grid(row=4, column=0, sticky=W)
        lblUsername = Entry(ButtonFrame ,font=("times new roman", 12, "bold"),textvariable=self.quantity, width=35)
        lblUsername.grid(row=4, column=1, sticky=W)
        
        lblUsername = Label(ButtonFrame, text="Risk Level : ", font=("times new roman", 12, "bold"), padx=2, pady=6)
        lblUsername.grid(row=5, column=0, sticky=W)
        lblUsername = Entry(ButtonFrame ,font=("times new roman", 12, "bold"),textvariable=self.riskLevel, width=35)
        lblUsername.grid(row=5, column=1, sticky=W)
        
        lblUsername = Label(ButtonFrame, text="Total Returns : ", font=("times new roman", 12, "bold"), padx=2, pady=6)
        lblUsername.grid(row=6, column=0, sticky=W)
        lblUsername = Entry(ButtonFrame ,font=("times new roman", 12, "bold"),textvariable=self.totalReturns, width=35)
        lblUsername.grid(row=6, column=1, sticky=W)
        
        lblUsername = Label(ButtonFrame, text="Annualized Returns : ", font=("times new roman", 12, "bold"), padx=2, pady=6)
        lblUsername.grid(row=7, column=0, sticky=W)
        lblUsername = Entry(ButtonFrame ,font=("times new roman", 12, "bold"),textvariable=self.annualizedReturns, width=35)
        lblUsername.grid(row=7, column=1, sticky=W)

        btnLogin=Button(ButtonFrame, text="Fetch Data",bg="green",fg="white",command=self.fetch_data, font=("times new roman", 12, "bold"), width=23, padx=2, pady=6)
        btnLogin.grid(row=0, column=2)
        
        btnLogin=Button(ButtonFrame, text="Add/Update Data",bg="green",fg="white",command=self.add_update_data, font=("times new roman", 12, "bold"), width=23, padx=2, pady=6)
        btnLogin.grid(row=1, column=2)

        btnLogin=Button(ButtonFrame, text="Delete Data",bg="red",fg="white",command=self.delete_data, font=("times new roman", 12, "bold"), width=23, padx=2, pady=6)
        btnLogin.grid(row=2, column=2)
        
        btnLogin=Button(ButtonFrame, text="Market Data Window",bg="green",fg="white",command=self.open_mkd, font=("times new roman", 12, "bold"), width=23, padx=2, pady=6)
        btnLogin.grid(row=3, column=2)
        
        btnLogin=Button(ButtonFrame, text="Reports",bg="green",fg="white",command=self.open_mkd, font=("times new roman", 12, "bold"), width=23, padx=2, pady=6)
        btnLogin.grid(row=4, column=2)
    
    def fetch_data(self):
        conn=mysql.connector.connect(host="localhost", username="root", password="dbms@123", database="portfolio")
        my_cursor=conn.cursor()
        my_cursor.execute("CALL get_holdings(%s)", (self.userid.get(),))
        rows=my_cursor.fetchall()
        if len(rows)!=0:
            self.HoldingsP.delete(*self.HoldingsP.get_children())
            for i in rows:
                self.HoldingsP.insert("",END,values=i)
        conn.commit()
        conn.close()

    def get_cursor(self,event=""):
        cursor_row=self.HoldingsP.focus()
        content=self.HoldingsP.item(cursor_row)
        row=content["values"]
        self.holdingID.set(row[0])
        self.year.set(row[1])
        self.month.set(row[2])
        self.investID.set(row[3])
        self.quantity.set(row[5])
    
    def add_update_data(self):
        conn=mysql.connector.connect(host="localhost", username="root", password="dbms@123", database="portfolio")
        my_cursor=conn.cursor()
        if self.holdingID.get()=="":
            query = "CALL insert_holding(%s, %s, %s, %s, %s);"
            params = (self.userid.get(),self.year.get(), self.month.get(), self.investID.get(), self.quantity.get())
            my_cursor.execute(query,params)
            messagebox.showinfo("Success", "Added successful!")
        else:
            query = "CALL update_holding(%s, %s, %s, %s, %s, %s)"
            params = (self.holdingID.get(),self.userid.get(),self.year.get(), self.month.get(), self.investID.get(), self.quantity.get())
            my_cursor.execute(query,params)
            messagebox.showinfo("Success", "Updated successful!")
        conn.commit()
        conn.close()
        self.fetch_data()
    
    def delete_data(self):
        conn=mysql.connector.connect(host="localhost", username="root", password="dbms@123", database="portfolio")
        my_cursor=conn.cursor()
        my_cursor.execute("CALL delete_holding(%s)", (self.holdingID.get(),))
        conn.commit()
        conn.close()
        self.fetch_data()
        
    def open_mkd(self):
        mkd_window = Tk()
        current = marketData(mkd_window)
        mkd_window.mainloop()
        
        

"""Description for portfolioPH Class:-
This defines a class marketData which creates a GUI window for a Portfolio Management System. 
The GUI includes two treeview tables: one for displaying market data and another for displaying investment instruments.
The __init__ method initializes instance variables and creates the main window with a frame for the market data table, 
a frame for buttons, and a frame for the investment instruments table.
The fetch_data method is not shown in the code, but it is likely a method that retrieves market data and inserts it into
the market data table.
The get_cursor method is not shown in the code, but it is likely a method that retrieves the currently selected row in 
the market data table.
Overall, this code sets up the basic structure for a Portfolio Management System GUI and provides a way to display market data and 
investment instruments in treeview tables. However, more functionality would need to be added to make the system useful for managing 
a portfolio.
"""
class marketData:
    def __init__(self, root):
        self.year = StringVar()
        self.month = StringVar()
        self.investID = StringVar()
        self.value = StringVar()
        self.tSymbol = StringVar()
        self.type = StringVar()
        self.name = StringVar()
        self.root = root
        self.root.title("Portfolio Management System")
        self.root.geometry("1280x1000+0+0")

        MainFrame = Frame(self.root, bd=0,padx=10, relief=RIDGE)
        MainFrame.place(x=0, y=0, width=1280, height = 1000)

        lblHoldings = Label(MainFrame, text="Market Data", font=("times new roman", 12, "bold"), padx=0, pady=6)
        lblHoldings.grid(row=0, column=0, sticky=W)

         # ==============================Details Frame==========================
        Detailsframe=Frame(MainFrame, bd=0,padx=0, relief=RIDGE)
        Detailsframe.place(x=0, y=40, width=1200, height = 300)
        # =========================table================================
        scroll_x=ttk.Scrollbar(Detailsframe, orient=HORIZONTAL)
        scroll_y=ttk.Scrollbar(Detailsframe, orient=VERTICAL)
        # old self.HoldingsP=ttk.Treeview(Detailsframe, column=("holdingsID", "year", "month", "name", "quantity", "riskLevel", "totalReturns", "annualizedReturns"), xscrollcommand=scroll_x.set, yscrollcommand=scroll_y.set)
        self.HoldingsP=ttk.Treeview(Detailsframe, column=("year", "month", "investID", "value"), xscrollcommand=scroll_x.set, yscrollcommand=scroll_y.set)
        scroll_x.pack(side=BOTTOM,fill=X)
        scroll_y.pack(side=RIGHT,fill=Y)

        scroll_x=ttk.Scrollbar(command=self.HoldingsP.xview)
        scroll_y=ttk.Scrollbar(command=self.HoldingsP.yview)

        self.HoldingsP.heading("year", text="Year")
        self.HoldingsP.heading("month", text="Month")
        self.HoldingsP.heading("investID", text="Invest ID")
        self.HoldingsP.heading("value", text="value")
        

        self.HoldingsP["show"]="headings"
        
        
        self.HoldingsP.column("year", width=100)
        self.HoldingsP.column("month", width=100)
        self.HoldingsP.column("investID", width=100)
        self.HoldingsP.column("value", width=100)    
       
        
        self.HoldingsP.pack(fill=BOTH, expand=1)

        # Button Frame
        ButtonFrame=Frame(MainFrame, bd=0,padx=0, relief=RIDGE)
        ButtonFrame.place(x=0, y=310, width=1200, height = 90)
        
        self.HoldingsP.pack(fill=BOTH, expand=1)
        self.HoldingsP.bind("<ButtonRelease-1>",self.get_cursor)
        btnLogin=Button(ButtonFrame, text="Fetch Market Data",bg="green",fg="white",command=self.fetch_data, font=("times new roman", 12, "bold"), width=23, padx=2, pady=6)
        btnLogin.grid(row=0, column=0)
        lblHoldings = Label(ButtonFrame, text="Investment Instruments", font=("times new roman", 12, "bold"), padx=0, pady=6)
        lblHoldings.grid(row=1, column=0, sticky=W)
  
                #================================== Investment Instruments Table=====================================
        
        
        Detailframe=Frame(MainFrame, bd=0,padx=0, relief=RIDGE)
        Detailframe.place(x=0, y=400, width=1200, height = 300)
        # =========================table================================
        scroll_x=ttk.Scrollbar(Detailframe, orient=HORIZONTAL)
        scroll_y=ttk.Scrollbar(Detailframe, orient=VERTICAL)
        # old self.HoldingsP=ttk.Treeview(Detailsframe, column=("holdingsID", "year", "month", "name", "quantity", "riskLevel", "totalReturns", "annualizedReturns"), xscrollcommand=scroll_x.set, yscrollcommand=scroll_y.set)
        self.HoldingsI=ttk.Treeview(Detailframe, column=("investID", "tSymbol", "type", "name"), xscrollcommand=scroll_x.set, yscrollcommand=scroll_y.set)
        scroll_x.pack(side=BOTTOM,fill=X)
        scroll_y.pack(side=RIGHT,fill=Y)

        scroll_x=ttk.Scrollbar(command=self.HoldingsI.xview)
        scroll_y=ttk.Scrollbar(command=self.HoldingsI.yview)

        self.HoldingsI.heading("investID", text="Invest ID")
        self.HoldingsI.heading("tSymbol", text="tSymbol")
        self.HoldingsI.heading("type", text="type")
        self.HoldingsI.heading("name", text="name")
        self.HoldingsI["show"]="headings"
        
    
        self.HoldingsI.column("investID", width=100)
        self.HoldingsI.column("tSymbol", width=100) 
        self.HoldingsI.column("type", width=100)    
        self.HoldingsI.column("name", width=100)   
        iiButtonFrame=Frame(MainFrame, bd=0,padx=0, relief=RIDGE)
        iiButtonFrame.place(x=0, y=720, width=1200, height = 50)
        
        self.HoldingsI.pack(fill=BOTH, expand=1)
        self.HoldingsI.bind("<ButtonRelease-1>",self.get_cursor_ii)
        btnLogin=Button(iiButtonFrame, text="Fetch Investment instruments",bg="green",fg="white",command=self.fetch_ii, font=("times new roman", 12, "bold"), width=23, padx=2, pady=6)
        btnLogin.grid(row=0, column=2)
        
    def fetch_data(self):
        conn=mysql.connector.connect(host="localhost", username="root", password="dbms@123", database="portfolio")
        my_cursor=conn.cursor()
        my_cursor.execute("SELECT * FROM market_data")
        rows=my_cursor.fetchall()
        if len(rows)!=0:
            self.HoldingsP.delete(*self.HoldingsP.get_children())
            for i in rows:
                self.HoldingsP.insert("",END,values=i)
        conn.commit()
        conn.close()

    def get_cursor(self,event=""):
        cursor_row=self.HoldingsP.focus()
        content=self.HoldingsP.item(cursor_row)
        row=content["values"]
        # self.holdingID.set(row[0])
        self.year.set(row[0])
        self.month.set(row[1])
        self.investID.set(row[2])
        self.value.set(row[3])
        
    def fetch_ii(self):
        conn=mysql.connector.connect(host="localhost", username="root", password="dbms@123", database="portfolio")
        my_cursor=conn.cursor()
        my_cursor.execute("SELECT * FROM investment_instruments")
        rows=my_cursor.fetchall()
        if len(rows)!=0:
            self.HoldingsI.delete(*self.HoldingsI.get_children())
            for i in rows:
                self.HoldingsI.insert("",END,values=i)
        conn.commit()
        conn.close()
        
    def get_cursor_ii(self,event=""):
        cursor_row=self.HoldingsI.focus()
        content=self.HoldingsI.item(cursor_row)
        row=content["values"]
        # self.holdingID.set(row[0])
        self.investID.set(row[0])
        self.tSymbol.set(row[1])
        self.type.set(row[2])
        self.name.set(row[3])
        

# main function of python
logonWindow = Tk()
current = login(logonWindow)
logonWindow.mainloop()

if guserID != "":
    portfolioPHWindow = Tk()
    current = portfolioPH(portfolioPHWindow)
    portfolioPHWindow.mainloop()
else:
    messagebox.showerror("Error", "Login Unsuccessful"+"\n"+"Please try again later")
    exit()

