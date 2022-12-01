using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class Saberslay : ShaderGUI {
    public static void linkButton(int Width, int Height, string title, string link) {
        if (GUILayout.Button(title, GUILayout.Width(Width), GUILayout.Height(Height))) {
            Application.OpenURL(link);
        }
    }
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties) {
        // render the default gui
        base.OnGUI(materialEditor, properties);

        EditorGUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        Saberslay.linkButton(70, 20, "Github", "https://github.com/saberslay/SaberslayShaders");
        GUILayout.Space(2);
        Saberslay.linkButton(70, 20, "Donate", "https://paypal.me/saberslay");
        GUILayout.FlexibleSpace();
        EditorGUILayout.EndHorizontal();
        
    }
}