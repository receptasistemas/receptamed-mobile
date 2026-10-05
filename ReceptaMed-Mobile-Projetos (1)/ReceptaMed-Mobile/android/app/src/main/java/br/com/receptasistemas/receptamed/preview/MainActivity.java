package br.com.receptasistemas.receptamed.preview;
import android.app.Activity;
import android.app.AlertDialog;
import android.os.Bundle;
import android.content.Intent;
import android.net.Uri;
import android.graphics.Color;
import android.view.View;
import android.webkit.*;
import android.widget.*;

public class MainActivity extends Activity {
 private static final String HOST="agendaflow-central-demo.vini-saccomani.chatgpt.site";
 private static final String HOME="https://"+HOST+"/app";
 private WebView web; private TextView error;
 private boolean internal(Uri u){return "https".equals(u.getScheme())&&HOST.equals(u.getHost())&&(u.getPort()==-1||u.getPort()==443);}
 private void external(Uri u){if(u==null)return;String s=u.getScheme();if(!"https".equals(s)&&!"mailto".equals(s)&&!"tel".equals(s))return;try{startActivity(new Intent(Intent.ACTION_VIEW,u));}catch(Exception e){Toast.makeText(this,"Não foi possível abrir o navegador.",Toast.LENGTH_LONG).show();}}
 private void openBrowser(){String u=web.getUrl();external(Uri.parse(u!=null&&internal(Uri.parse(u))?u:HOME));}
 @Override public void onCreate(Bundle state){super.onCreate(state);
  WebView.setWebContentsDebuggingEnabled(false);
  LinearLayout root=new LinearLayout(this);root.setOrientation(LinearLayout.VERTICAL);root.setBackgroundColor(Color.WHITE);
  root.setOnApplyWindowInsetsListener((v,insets)->{v.setPadding(insets.getSystemWindowInsetLeft(),insets.getSystemWindowInsetTop(),insets.getSystemWindowInsetRight(),insets.getSystemWindowInsetBottom());return insets;});
  error=new TextView(this);error.setText("Sem conexão. Confira a internet e toque aqui para tentar novamente.");error.setTextSize(18);error.setOnClickListener(v->{error.setVisibility(View.GONE);web.reload();});error.setPadding(20,20,20,20);error.setVisibility(View.GONE);root.addView(error);
  web=new WebView(this);root.addView(web,new LinearLayout.LayoutParams(-1,0,1));setContentView(root);
  WebSettings settings=web.getSettings();settings.setJavaScriptEnabled(true);settings.setDomStorageEnabled(true);settings.setAllowFileAccess(false);settings.setAllowContentAccess(false);settings.setMixedContentMode(WebSettings.MIXED_CONTENT_NEVER_ALLOW);settings.setCacheMode(WebSettings.LOAD_NO_CACHE);settings.setSupportMultipleWindows(true);settings.setJavaScriptCanOpenWindowsAutomatically(false);settings.setSafeBrowsingEnabled(true);
  CookieManager.getInstance().setAcceptCookie(true);CookieManager.getInstance().setAcceptThirdPartyCookies(web,false);
  web.setWebViewClient(new WebViewClient(){
   @Override public boolean shouldOverrideUrlLoading(WebView v,WebResourceRequest r){if(internal(r.getUrl()))return false;if(r.isForMainFrame())external(r.getUrl());return true;}
   @Override public void onPageStarted(WebView v,String url,android.graphics.Bitmap icon){error.setVisibility(View.GONE);}
   @Override public void onReceivedError(WebView v,WebResourceRequest r,WebResourceError e){if(r.isForMainFrame())error.setVisibility(View.VISIBLE);}
   @Override public void onReceivedSslError(WebView v,SslErrorHandler h,android.net.http.SslError e){h.cancel();error.setVisibility(View.VISIBLE);}
  });
  web.setWebChromeClient(new WebChromeClient(){
   @Override public boolean onCreateWindow(WebView v,boolean dialog,boolean userGesture,android.os.Message result){if(!userGesture)return false;WebView popup=new WebView(MainActivity.this);popup.setWebViewClient(new WebViewClient(){@Override public boolean shouldOverrideUrlLoading(WebView w,WebResourceRequest r){Uri uri=r.getUrl();if(internal(uri))web.loadUrl(uri.toString());else external(uri);w.destroy();return true;}});((WebView.WebViewTransport)result.obj).setWebView(popup);result.sendToTarget();return true;}
  });
  web.setDownloadListener((url,agent,disposition,mime,length)->new AlertDialog.Builder(this).setTitle("Exportar relatório").setMessage("Nesta versão de teste, abra o sistema no navegador e gere o arquivo por lá. Pode ser necessário entrar novamente.").setPositiveButton("Abrir navegador",(d,w)->openBrowser()).setNegativeButton("Voltar",null).show());
  web.loadUrl(HOME);
 }
 private void goBack(){if(web.canGoBack())web.goBack();else finish();}
 @Override public void onBackPressed(){goBack();}
 @Override protected void onPause(){super.onPause();CookieManager.getInstance().flush();web.onPause();}
 @Override protected void onResume(){super.onResume();if(web!=null)web.onResume();}
 @Override protected void onDestroy(){if(web!=null){web.stopLoading();web.destroy();}super.onDestroy();}
}
