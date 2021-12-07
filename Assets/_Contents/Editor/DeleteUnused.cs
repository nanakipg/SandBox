using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEditor;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

public class DeleteUnused : EditorWindow
{
    [MenuItem("Assets/Tools/Timeline/Unusedを消去",false,1)]
    static void Open()
    {
        var window = GetWindow<DeleteUnused>(nameof(DeleteUnused));
        window.Show();
    }

    private void OnGUI()
    {
        if (GUILayout.Button("実行する"))
        {
            Check();
        }
    }

    private void Check()
    {
        List<GameObject> objects = new List<GameObject>();
        var pd =  Selection.activeGameObject.GetComponent<PlayableDirector>();
        var asset = pd.playableAsset;
        var path = AssetDatabase.GetAssetPath(asset);
        // シリアライズ化
        var so = new SerializedObject(pd);
        so.Update();

        // m_SceneBindingsの変数を取得
        var prop = so.FindProperty("m_SceneBindings");
        
        for (int i = 0; i < prop.arraySize; i++)
        {
            // m_SceneBindingsの配列のi番目のkeyのプロパティを取得
            var key = prop.GetArrayElementAtIndex(i).FindPropertyRelative("key");
            // keyの参照しているオブジェクトのインスタンスIDを取得
            var tmp = key.objectReferenceInstanceIDValue;
            // インスタンスIDを元にアセットのパスを取得する
            var propPath = AssetDatabase.GetAssetPath(tmp);
            Debug.Log(propPath);
            
            if (path != propPath)
            {
                prop.DeleteArrayElementAtIndex(i);
                i--;
            }
        }
        so.ApplyModifiedProperties();
        
    }
}
