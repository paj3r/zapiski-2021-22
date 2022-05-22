﻿namespace PathTracer
{
  partial class MainWindow
  {
    /// <summary>
    /// Required designer variable.
    /// </summary>
    private System.ComponentModel.IContainer components = null;

    /// <summary>
    /// Clean up any resources being used.
    /// </summary>
    /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
    protected override void Dispose(bool disposing)
    {
      if (disposing && (components != null))
      {
        components.Dispose();
      }
      base.Dispose(disposing);
    }

    #region Windows Form Designer generated code

    /// <summary>
    /// Required method for Designer support - do not modify
    /// the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent()
    {
            this.pbxRender = new System.Windows.Forms.PictureBox();
            this.btnDoit = new System.Windows.Forms.Button();
            this.panel1 = new System.Windows.Forms.Panel();
            this.flowLayoutPanel1 = new System.Windows.Forms.FlowLayoutPanel();
            this.lblSPP = new System.Windows.Forms.Label();
            this.lblTime = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.pbxRender)).BeginInit();
            this.panel1.SuspendLayout();
            this.flowLayoutPanel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // pbxRender
            // 
            this.pbxRender.Dock = System.Windows.Forms.DockStyle.Fill;
            this.pbxRender.Location = new System.Drawing.Point(0, 0);
            this.pbxRender.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.pbxRender.Name = "pbxRender";
            this.pbxRender.Size = new System.Drawing.Size(1326, 689);
            this.pbxRender.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pbxRender.TabIndex = 0;
            this.pbxRender.TabStop = false;
            this.pbxRender.Click += new System.EventHandler(this.pbxRender_Click);
            // 
            // btnDoit
            // 
            this.btnDoit.Dock = System.Windows.Forms.DockStyle.Fill;
            this.btnDoit.Location = new System.Drawing.Point(0, 0);
            this.btnDoit.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.btnDoit.Name = "btnDoit";
            this.btnDoit.Size = new System.Drawing.Size(1133, 51);
            this.btnDoit.TabIndex = 1;
            this.btnDoit.Text = "Trace";
            this.btnDoit.UseVisualStyleBackColor = true;
            this.btnDoit.Click += new System.EventHandler(this.btnDoit_Click);
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.btnDoit);
            this.panel1.Controls.Add(this.flowLayoutPanel1);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panel1.Location = new System.Drawing.Point(0, 689);
            this.panel1.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(1326, 51);
            this.panel1.TabIndex = 2;
            // 
            // flowLayoutPanel1
            // 
            this.flowLayoutPanel1.AutoSize = true;
            this.flowLayoutPanel1.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.flowLayoutPanel1.Controls.Add(this.lblSPP);
            this.flowLayoutPanel1.Controls.Add(this.lblTime);
            this.flowLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Right;
            this.flowLayoutPanel1.Location = new System.Drawing.Point(1133, 0);
            this.flowLayoutPanel1.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.flowLayoutPanel1.Name = "flowLayoutPanel1";
            this.flowLayoutPanel1.Size = new System.Drawing.Size(193, 51);
            this.flowLayoutPanel1.TabIndex = 3;
            this.flowLayoutPanel1.WrapContents = false;
            // 
            // lblSPP
            // 
            this.lblSPP.AutoSize = true;
            this.lblSPP.Location = new System.Drawing.Point(4, 0);
            this.lblSPP.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblSPP.Name = "lblSPP";
            this.lblSPP.Padding = new System.Windows.Forms.Padding(8, 15, 0, 0);
            this.lblSPP.Size = new System.Drawing.Size(65, 35);
            this.lblSPP.TabIndex = 2;
            this.lblSPP.Text = "SPP: 0";
            this.lblSPP.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lblTime
            // 
            this.lblTime.AutoSize = true;
            this.lblTime.Location = new System.Drawing.Point(77, 0);
            this.lblTime.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblTime.Name = "lblTime";
            this.lblTime.Padding = new System.Windows.Forms.Padding(8, 15, 0, 0);
            this.lblTime.Size = new System.Drawing.Size(112, 35);
            this.lblTime.TabIndex = 3;
            this.lblTime.Text = "Time: 0:00:00";
            this.lblTime.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // MainWindow
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(9F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1326, 740);
            this.Controls.Add(this.pbxRender);
            this.Controls.Add(this.panel1);
            this.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.Name = "MainWindow";
            this.Text = "PathTracer Preview";
            this.Load += new System.EventHandler(this.MainWindow_Load);
            ((System.ComponentModel.ISupportInitialize)(this.pbxRender)).EndInit();
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.flowLayoutPanel1.ResumeLayout(false);
            this.flowLayoutPanel1.PerformLayout();
            this.ResumeLayout(false);

    }

    #endregion

    private System.Windows.Forms.PictureBox pbxRender;
    private System.Windows.Forms.Button btnDoit;
    private System.Windows.Forms.Panel panel1;
    private System.Windows.Forms.Label lblSPP;
    private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel1;
    private System.Windows.Forms.Label lblTime;
  }
}

